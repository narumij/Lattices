/*
 modified
 */

/*
    Copyright (C) 2016 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information
    
    Abstract:
    This is the Recents Manager and handles saving the recents list as it changes as well as notifies the delegate when recents are deleted / modified in a way that requires the UI to be refreshed.
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
    The delegate protocol implemented by the object that receives our results.
    We pass the updated list of results as well as a set of animations.
*/
protocol RecentModelObjectsManagerDelegate: class {
    func recentsManagerResultsDidChange(_ results: [RecentModelObject], animations: [DocumentBrowserAnimation])
}

/**
    The `RecentModelObjectsManager` manages our list of recents.  It receives
    notifications from the recents as a RecentModelObjectDelegate and computes
    animations from the notifications which is submits to it's delegate.
*/
class RecentModelObjectsManager: RecentModelObjectDelegate {
    // MARK: - Properties
    
    var recentModelObjects = [RecentModelObject]()
    
    static let maxRecentModelObjectCount = 3
    
    static let recentsKey = "recents"
    
    fileprivate let workerQueue: OperationQueue = {
        let coordinationQueue = OperationQueue()
        
        coordinationQueue.name = "jp.zenithgear.Lattices.recentobjectsmanager.workerQueue"
        
        coordinationQueue.maxConcurrentOperationCount = 1
        
        return coordinationQueue
    }()

    
    weak var delegate: RecentModelObjectsManagerDelegate? {
        didSet {
            /*
                If we already have results, we send them to the delegate as an
                initial update.
            */
            delegate?.recentsManagerResultsDidChange(recentModelObjects, animations: [.reload])
        }
    }
    
    // MARK: - Initialization
    
    init() {
        loadRecents()
    }
    
    deinit {
        // Be sure we are no longer listening for file presenter notifications.
        for recent in recentModelObjects {
            NSFileCoordinator.removeFilePresenter(recent)
        }
    }
    
    // MARK: - Recent Saving / Loading
    
    fileprivate func loadRecents() {
        workerQueue.addOperation {
            let defaults = UserDefaults.standard
            
            guard let loadedRecentData = defaults.object(forKey: RecentModelObjectsManager.recentsKey) as? [Data] else {
                return
            }
            
            let loadedRecents = loadedRecentData.flatMap { recentModelObjectData in
                return NSKeyedUnarchiver.unarchiveObject(with: recentModelObjectData) as? RecentModelObject
            }
            
            // Remove any existing recents we may have already stored in memory.
            for recent in self.recentModelObjects {
                NSFileCoordinator.removeFilePresenter(recent)
            }
            
            /* 
                Add all newly loaded recents to the recents set and register for
                `NSFilePresenter` notifications on all of them.
            */
            for recent in loadedRecents {
                recent.delegate = self
                NSFileCoordinator.addFilePresenter(recent)
            }
            
            self.recentModelObjects = loadedRecents
            
            // Check if the bookmark data is stale and resave the recents if it is.
            for recent in loadedRecents {
                if recent.bookmarkDataNeedsSave {
                    self.saveRecents()
                }
            }
            
            OperationQueue.main.addOperation {
                // Notify our delegate that the initial recents were loaded.
                self.delegate?.recentsManagerResultsDidChange(self.recentModelObjects, animations: [.reload])
            }
        }
    }
    
    fileprivate func saveRecents() {
        let recentModels = recentModelObjects.map { recentModelObject in
            return NSKeyedArchiver.archivedData(withRootObject: recentModelObject)
        }
        
        UserDefaults.standard.set(recentModels, forKey: RecentModelObjectsManager.recentsKey)
    }
    
    // MARK: - Recent List Management
    
    fileprivate func removeRecentModelObject(_ recent: RecentModelObject) {
        // Remove the file presenter so we stop getting notifications on the removed recent.
        NSFileCoordinator.removeFilePresenter(recent)
        
        /*
            Remove the recent from the array and save the recents array to disk
            so they will reflect the correct state when the app is relaunched.
        */
        guard let index = recentModelObjects.index(of: recent) else { return }

        recentModelObjects.remove(at: index)

        saveRecents()
    }
    
    func addURLToRecents(_ URL: Foundation.URL) {
        workerQueue.addOperation {
            // Add the recent to the recents manager.
            guard let recent = RecentModelObject(URL: URL) else { return }

            var animations = [DocumentBrowserAnimation]()
            
            if let index = self.recentModelObjects.index(of: recent) {
                self.recentModelObjects.remove(at: index)
                
                if index != 0 {
                    animations += [.move(fromIndex: index, toIndex: 0)]
                }
            }
            else {
                recent.delegate = self
                
                NSFileCoordinator.addFilePresenter(recent)
                
                animations += [.add(index: 0)]
            }
            
            self.recentModelObjects.insert(recent, at: 0)
            
            // Prune down the recent documents if there are too many.
            while self.recentModelObjects.count > RecentModelObjectsManager.maxRecentModelObjectCount {
                self.removeRecentModelObject(self.recentModelObjects.last!)
                
                animations += [.delete(index: self.recentModelObjects.count - 1)]
            }
            
            OperationQueue.main.addOperation {
                self.delegate?.recentsManagerResultsDidChange(self.recentModelObjects, animations: animations)
            }
        
            self.saveRecents()
        }
    }
    
    // MARK: - RecentModelObjectDelegate
    
    func recentWasDeleted(_ recent: RecentModelObject) {
        self.workerQueue.addOperation {
            guard let index = self.recentModelObjects.index(of: recent) else { return }
            
            self.removeRecentModelObject(recent)
            
            OperationQueue.main.addOperation {
                self.delegate?.recentsManagerResultsDidChange(self.recentModelObjects, animations: [
                    .delete(index: index)
                ])
            }
        }
    }
    
    func recentNeedsReload(_ recent: RecentModelObject) {
        self.workerQueue.addOperation {
            guard let index = self.recentModelObjects.index(of: recent) else { return }
            
            OperationQueue.main.addOperation {
                self.delegate?.recentsManagerResultsDidChange(self.recentModelObjects, animations: [
                    .update(index: index)
                ])
            }
        }
    }
}
