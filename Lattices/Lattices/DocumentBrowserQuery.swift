/*
 modified
 */

/*
    Copyright (C) 2016 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information
    
    Abstract:
    This is the Browser Query which manages results form an `NSMetadataQuery` to compute which documents to show in the Browser UI / animations to display when cells move.
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
    The delegate protocol implemented by the object that receives our results. We
    pass the updated list of results as well as a set of animations.
*/
protocol DocumentBrowserQueryDelegate: class {
    func documentBrowserQueryResultsDidChangeWithResults(_ results: [DocumentBrowserModelObject], animations: [DocumentBrowserAnimation])
}

/**
    The DocumentBrowserQuery wraps an `NSMetadataQuery` to insulate us from the
    queueing and animation concerns. It runs the query and computes animations
    from the results set.
*/
class DocumentBrowserQuery: NSObject {
    // MARK: - Properties

    fileprivate var metadataQuery: NSMetadataQuery
    
    fileprivate var previousQueryObjects: NSOrderedSet?
    
    fileprivate let workerQueue: OperationQueue = {
        let workerQueue = OperationQueue()
        
        workerQueue.name = "jp.zenithgear.Lattices.browserdatasource.workerQueue"

        workerQueue.maxConcurrentOperationCount = 1
        
        return workerQueue
    }()

    var delegate: DocumentBrowserQueryDelegate? {
        didSet {
            /*
                If we already have results, we send them to the delegate as an
                initial update.
            */
            workerQueue.addOperation {
                guard let results = self.previousQueryObjects else { return }
                
                self.updateWithResults(results, removedResults: NSOrderedSet(), addedResults: NSOrderedSet(), changedResults: NSOrderedSet())
            }
        }
    }

    // MARK: - Initialization

    override init() {
        metadataQuery = NSMetadataQuery()
        
        // Filter only our document type.
        let filePattern = String(format: "*.%@", DocumentBrowserController.documentExtension)
        metadataQuery.predicate = NSPredicate(format: "%K LIKE %@", NSMetadataItemFSNameKey, filePattern)
        
        /*
            Ask for both in-container documents and external documents so that
            the user gets to interact with all the documents she or he has ever
            opened in the application, without having to pull the document picker
            again and again.
        */
        metadataQuery.searchScopes = [
            NSMetadataQueryUbiquitousDocumentsScope,
            NSMetadataQueryAccessibleUbiquitousExternalDocumentsScope
        ]

        /*
            We supply our own serializing queue to the `NSMetadataQuery` so that we
            can perform our own background work in sync with item discovery.
            Note that the operationQueue of the `NSMetadataQuery` must be serial.
        */
        metadataQuery.operationQueue = workerQueue

        super.init()

        NotificationCenter.default.addObserver(self, selector: #selector(DocumentBrowserQuery.finishGathering(_:)), name: NSNotification.Name.NSMetadataQueryDidFinishGathering, object: metadataQuery)

        NotificationCenter.default.addObserver(self, selector: #selector(DocumentBrowserQuery.queryUpdated(_:)), name: NSNotification.Name.NSMetadataQueryDidUpdate, object: metadataQuery)

        metadataQuery.start()
    }
    
    // MARK: - Notifications

    @objc func queryUpdated(_ notification: Notification) {
        let changedMetadataItems = (notification as NSNotification).userInfo?[NSMetadataQueryUpdateChangedItemsKey] as? [NSMetadataItem]
        
        let removedMetadataItems = (notification as NSNotification).userInfo?[NSMetadataQueryUpdateRemovedItemsKey] as? [NSMetadataItem]
        
        let addedMetadataItems = (notification as NSNotification).userInfo?[NSMetadataQueryUpdateAddedItemsKey] as? [NSMetadataItem]
        
        let changedResults = buildModelObjectSet(changedMetadataItems ?? [])
        let removedResults = buildModelObjectSet(removedMetadataItems ?? [])
        let addedResults = buildModelObjectSet(addedMetadataItems ?? [])
        
        let newResults = buildQueryResultSet()

        updateWithResults(newResults, removedResults: removedResults, addedResults: addedResults, changedResults: changedResults)
    }

    @objc func finishGathering(_ notification: Notification) {
        metadataQuery.disableUpdates()
        
        let metadataQueryResults = metadataQuery.results as! [NSMetadataItem]
        
        let results = buildModelObjectSet(metadataQueryResults)
                
        metadataQuery.enableUpdates()

        updateWithResults(results, removedResults: NSOrderedSet(), addedResults: NSOrderedSet(), changedResults: NSOrderedSet())
    }

    // MARK: - Result handling/animations

    fileprivate func buildModelObjectSet(_ objects: [NSMetadataItem]) -> NSOrderedSet {
        // Create an ordered set of model objects.
        var array = objects.map { DocumentBrowserModelObject(item: $0) }

        // Sort the array by filename.
        array.sort { $0.displayName < $1.displayName }

        let results = NSMutableOrderedSet(array: array)

        return results
    }
    
    fileprivate func buildQueryResultSet() -> NSOrderedSet {
        /*
           Create an ordered set of model objects from the query's current
           result set.
        */

        metadataQuery.disableUpdates()

        let metadataQueryResults = metadataQuery.results as! [NSMetadataItem]

        let results = buildModelObjectSet(metadataQueryResults)

        metadataQuery.enableUpdates()

        return results
    }

    fileprivate func computeAnimationsForNewResults(_ newResults: NSOrderedSet, oldResults: NSOrderedSet, removedResults: NSOrderedSet, addedResults: NSOrderedSet, changedResults: NSOrderedSet) -> [DocumentBrowserAnimation] {
        /*
           From two sets of result objects, create an array of animations that
           should be run to morph old into new results.
        */
        
        let oldResultAnimations: [DocumentBrowserAnimation] = removedResults.array.flatMap { removedResult in
            let oldIndex = oldResults.index(of: removedResult)
            
            guard oldIndex != NSNotFound else { return nil }
            
            return .delete(index: oldIndex)
        }
        
        let newResultAnimations: [DocumentBrowserAnimation] = addedResults.array.flatMap { addedResult in
            let newIndex = newResults.index(of: addedResult)
            
            guard newIndex != NSNotFound else { return nil }
            
            return .add(index: newIndex)
        }

        let movedResultAnimations: [DocumentBrowserAnimation] = changedResults.array.flatMap { movedResult in
            let newIndex = newResults.index(of: movedResult)
            let oldIndex = oldResults.index(of: movedResult)
            
            guard newIndex != NSNotFound else { return nil }
            guard oldIndex != NSNotFound else { return nil }
            guard oldIndex != newIndex   else { return nil }
            
            return .move(fromIndex: oldIndex, toIndex: newIndex)
        }

        // Find all the changed result animations.
        let changedResultAnimations: [DocumentBrowserAnimation] = changedResults.array.flatMap { changedResult in
            let index = newResults.index(of: changedResult)

            guard index != NSNotFound else { return nil }
            
            return .update(index: index)
        }
        
        return oldResultAnimations + changedResultAnimations + newResultAnimations + movedResultAnimations
    }

    fileprivate func updateWithResults(_ results: NSOrderedSet, removedResults: NSOrderedSet, addedResults: NSOrderedSet, changedResults: NSOrderedSet) {
        /*
            From a set of new result objects, we compute the necessary animations
            if applicable, then call out to our delegate.
        */

        /*
            We use the `NSOrderedSet` as a fast lookup for computing the animations,
            but use a simple array otherwise for convenience.
        */
        let queryResults = results.array as! [DocumentBrowserModelObject]

        let queryAnimations: [DocumentBrowserAnimation]

        if let oldResults = previousQueryObjects {
            queryAnimations = computeAnimationsForNewResults(results, oldResults: oldResults, removedResults: removedResults, addedResults: addedResults, changedResults: changedResults)
        }
        else {
            queryAnimations = [.reload]
        }

        // After computing updates, we hang on to the current results for the next round.
        previousQueryObjects = results

        OperationQueue.main.addOperation {
            self.delegate?.documentBrowserQueryResultsDidChangeWithResults(queryResults, animations: queryAnimations)
        }
    }
}
