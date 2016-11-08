/*
    Copyright (C) 2016 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information
    
    Abstract:
    This is the model object which represents one document on disk.
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

import UIKit

/**
    This class is used as an immutable value object to represent an item in our
    document browser. Note the custom implementation of `hash` and `isEqual(_:)`, 
    which are required so we can later look up instances in our results set.
*/
class DocumentBrowserModelObject: NSObject, ModelObject {
    // MARK: - Properties

    fileprivate(set) var displayName: String
    
    fileprivate(set) var subtitle = ""
    
    fileprivate(set) var URL: Foundation.URL

    fileprivate(set) var metadataItem: NSMetadataItem

    // MARK: - Initialization
    required init(item: NSMetadataItem) {
        displayName = item.value(forAttribute: NSMetadataItemDisplayNameKey) as! String
        
        /*
            External documents are not located in the app's ubiquitous container.
            They could either be in another app's ubiquitous container or in the
            user's iCloud Drive folder, outside of the app's sandbox, but the user
            has granted the app access to the document by picking the document in
            the document picker or opening the document in the app on OS X.
            Throughout the system, the name of the document is decorated with the
            source container's name.
        */
        if let isExternal = item.value(forAttribute: NSMetadataUbiquitousItemIsExternalDocumentKey) as? Bool,
               let containerName = item.value(forAttribute: NSMetadataUbiquitousItemContainerDisplayNameKey) as? String
               , isExternal {
            subtitle = "in \(containerName)"
        }
        
        /*
            The `NSMetadataQuery` will send updates on the `NSMetadataItem` item.
            If the item is renamed or moved, the value for `NSMetadataItemURLKey`
            might change.
        */
        URL = item.value(forAttribute: NSMetadataItemURLKey) as! Foundation.URL
        
        metadataItem = item
    }
    
    // MARK: - Override
    
    /**
        Two `DocumentBrowserModelObject` are equal iff their metadata items are equal.
        We use the metadata item instead of other properties like the URL to compare
        equality in order to track documents across renames.
    */
    override func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? DocumentBrowserModelObject else {
            return false
        }
        
        return other.metadataItem.isEqual(metadataItem)
    }

    /// Hash method implemented to match `isEqual(_:)`'s constraints.
    override var hash: Int {
        return metadataItem.hash
    }
   
    // MARK: - CustomDebugStringConvertible
    
    override var debugDescription: String {
        return super.debugDescription + " " + displayName
    }
}
