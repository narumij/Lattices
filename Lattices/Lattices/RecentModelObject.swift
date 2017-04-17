/*
    Copyright (C) 2016 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information
    
    Abstract:
    This is the RecentsModelObject which listens for notifications about a single recent object. It then forwards the notifications on to the delegate.
*/

/* LICENSE.txt
 Sample code project: ShapeEdit: Building a Simple iCloud Document App
 Version: 1.3

 IMPORTANT:  This Apple software is supplied to you by Apple
 Inc. ("Apple") in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Apple software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Apple software.

 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.

 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.

 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.

 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 */

import Foundation

/**
    The delegate protocol implemented by the object that wants to be notified
    about changes to this recent.
*/
protocol RecentModelObjectDelegate: class {
    func recentWasDeleted(_ recent: RecentModelObject)
    func recentNeedsReload(_ recent: RecentModelObject)
}

/**
    The `RecentModelObject` manages a single recent on disk.  It is registered
    as a file presenter and as such is notified when the recent changes on
    disk.  It forwards these notifications on to its delegate.
*/
class RecentModelObject: NSObject, NSFilePresenter, ModelObject {
    // MARK: - Properties

    weak var delegate: RecentModelObjectDelegate?
    
    fileprivate(set) var URL: Foundation.URL
    
    fileprivate(set) var displayName = ""
    
    fileprivate(set) var subtitle = ""
    
    fileprivate(set) var bookmarkDataNeedsSave = false
    
    fileprivate var bookmarkData: Data?
    
    fileprivate var isSecurityScoped = false
    
    static let displayNameKey = "displayName"
    static let subtitleKey = "subtitle"
    static let bookmarkKey = "bookmark"

    var presentedItemURL: Foundation.URL? {
        return URL
    }

    var presentedItemOperationQueue: OperationQueue {
        return OperationQueue.main
    }
    
    deinit {
        URL.stopAccessingSecurityScopedResource()
    }

    // MARK: - NSCoding
    
    required init?(URL: Foundation.URL) {
        self.URL = URL
        
        do {
            super.init()
            
            try refreshNameAndSubtitle()
            
            bookmarkDataNeedsSave = true
        }
        catch {
            return nil
        }
    }

    required init?(coder aDecoder: NSCoder) {
        do {
            displayName = aDecoder.decodeObject(of: NSString.self, forKey: RecentModelObject.displayNameKey)! as String
            
            subtitle = aDecoder.decodeObject(of: NSString.self, forKey: RecentModelObject.subtitleKey)! as String
            
            // Decode the bookmark into a URL.
            var bookmarkDataIsStale: ObjCBool = false

            guard let bookmark = aDecoder.decodeObject(of: NSData.self, forKey: RecentModelObject.bookmarkKey) else {
                throw ShapeEditError.bookmarkResolveFailed
            }
            
            bookmarkData = bookmark as Data
            
            URL = try (NSURL(resolvingBookmarkData: bookmark as Data, options: .withoutUI, relativeTo: nil, bookmarkDataIsStale: &bookmarkDataIsStale) as URL)
            
            /*
                The URL is security-scoped for external documents, which live outside
                of the application's sandboxed container.
            */
            isSecurityScoped = URL.startAccessingSecurityScopedResource()
            
            if bookmarkDataIsStale.boolValue {
                self.bookmarkDataNeedsSave = true
                
                print("\(URL) is stale.")
            }
            
            super.init()
            
            do {
                try self.refreshNameAndSubtitle()
            }
            catch {
                // Ignore the error, use the stale display name.
            }
        }
        catch let error {
            print("bookmark for \(displayName) failed to resolve: \(error)")
            
            URL = NSURL() as URL
            
            bookmarkDataNeedsSave = false
            
            self.bookmarkData = Data()
            
            super.init()
            
            return nil
        }
    }
    
    func encodeWithCoder(_ aCoder: NSCoder) {
        do {
            aCoder.encode(displayName, forKey: RecentModelObject.displayNameKey)
            
            aCoder.encode(subtitle, forKey: RecentModelObject.subtitleKey)
            
            if bookmarkDataNeedsSave {
                /*
                    Encode our URL into a security scoped bookmark.  We need to be sure
                    to mark the bookmark as suitable for a bookmark file or it won't
                    resolve properly.
                */
                bookmarkData = try (URL as NSURL).bookmarkData(options: .suitableForBookmarkFile, includingResourceValuesForKeys: nil, relativeTo: nil)
                
                self.bookmarkDataNeedsSave = false
            }
            
            aCoder.encode(bookmarkData, forKey: RecentModelObject.bookmarkKey)
        }
        catch {
            print("bookmark for \(displayName) failed to encode: \(error).")
        }
    }

    // MARK: - NSFilePresenter Notifications
    
    func accommodatePresentedItemDeletion(completionHandler: @escaping (Error?) -> Void) {
        /*
            Notify our delegate that the recent was deleted, then call the completion 
            handler to allow for the deletion to go through.
        */
        delegate?.recentWasDeleted(self)

        completionHandler(nil)
    }

    func presentedItemDidMove(to newURL: URL) {
        /*
            Update our presented item URL to the new location, then notify our
            delegate that the recent needs to be refreshed in the UI.
        */
        URL = newURL
        
        do {
            try refreshNameAndSubtitle()
        }
        catch {
             // Ignore a failure here. We'll just keep the old display name.
        }
        
        delegate?.recentNeedsReload(self)
    }

    func presentedItemDidChange() {
        // Notify the delegate that the recent needs to be refreshed in the UI.
        delegate?.recentNeedsReload(self)
    }
    
    // MARK: - Initialization Support
   
    fileprivate func refreshNameAndSubtitle() throws {
        var refreshedName: AnyObject?

        try (URL as NSURL).getPromisedItemResourceValue(&refreshedName, forKey: URLResourceKey.localizedNameKey)
        
        displayName = refreshedName as! String
        
        let fileManager = FileManager.default
        
        if let ubiquitousContainer = fileManager.url(forUbiquityContainerIdentifier: nil) {
            var relationship: FileManager.URLRelationship = .other
            
            try fileManager.getRelationship(&relationship, ofDirectoryAt: ubiquitousContainer, toItemAt: URL)
            
            if relationship != .contains {
                var externalContainerName: AnyObject?
                
                try (URL as NSURL).getPromisedItemResourceValue(&externalContainerName, forKey: URLResourceKey.ubiquitousItemContainerDisplayNameKey)
                
                subtitle = "in \(externalContainerName as! String)"
            }
            else {
                subtitle = ""
            }
        }
        else {
            throw ShapeEditError.signedOutOfiCloud
        }
    }
    
    /// Two RecentModelObjects are equal iff their urls are equal.
    override func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? RecentModelObject else {
            return false
        }
        
        return (other.URL == URL)
    }
    
    /// Hash method implemented to match `isEqual(_:)`'s constraints.
    override var hash: Int {
        return (URL as NSURL).hash
    }
}
