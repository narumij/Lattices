/*
 modified
 */

/*
    Copyright (C) 2016 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information
    
    Abstract:
    This is the `DocumentBrowserController` which handles display of all elements of the Document Browser.  It listens for notifications from the `DocumentBrowserQuery`, `RecentModelObjectsManager`, and `ThumbnailCache` and updates the `UICollectionView` for the Document Browser when events
                occur.
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
    The `DocumentBrowserController` registers for notifications from the `ThumbnailCache`,
    the `RecentModelObjectsManager`, and the `DocumentBrowserQuery` and updates the UI for
    changes.  It also handles pushing the `DocumentViewController` when a document is
    selected.
*/
class DocumentBrowserController: UICollectionViewController, DocumentBrowserQueryDelegate, RecentModelObjectsManagerDelegate, ThumbnailCacheDelegate {
    
    // MARK: - Constants
    
    static let recentsSection = 0
    static let documentsSection = 1

    static let documentExtension = "cif"
    
    // MARK: - Properties
    
    var documents = [DocumentBrowserModelObject]()
    
    var recents = [RecentModelObject]()
    
    var browserQuery = DocumentBrowserQuery()
    
    let recentsManager = RecentModelObjectsManager()
    
    let thumbnailCache = ThumbnailCache(thumbnailSize: CGSize(width: 220, height: 270))

    fileprivate let coordinationQueue: OperationQueue = {
        let coordinationQueue = OperationQueue()
        
        coordinationQueue.name = "jp.zenithgear.Lattices.documentbrowser.coordinationQueue"
        
        return coordinationQueue
    }()
    
    // MARK: - View Controller Override

    override func awakeFromNib() {
        // Initialize ourself as the delegate of our created queries.
        browserQuery.delegate = self

        thumbnailCache.delegate = self
        
        recentsManager.delegate = self
        
        title = "My Favorite Crystals"
//        title = "iCloud Files"
    }

    override func viewDidAppear(_ animated: Bool) {
        /*
            Our app only supports iCloud Drive so display an error message when
            it is disabled.
        */
        if FileManager().ubiquityIdentityToken == nil {
            let alertController = UIAlertController(title: cloudDisabledAlertTitle, message: cloudDisabledAlertMessage, preferredStyle: .alert)
            
            let alertAction = UIAlertAction(title: cloudDisabledAlertDismiss, style: .default, handler: nil)
            
            alertController.addAction(alertAction)
            
            present(alertController, animated: true, completion: nil)
        }
        else {
            copyDeviceFilesIfNeeds()
            copySampleFilesIfNeeds()
        }
    }

    @IBAction func insertNewObject(_ sender: UIBarButtonItem) {
        // Create a document with the default template.
    }
    
    // MARK: - DocumentBrowserQueryDelegate

    func documentBrowserQueryResultsDidChangeWithResults(_ results: [DocumentBrowserModelObject], animations: [DocumentBrowserAnimation]) {
        if animations == [.reload] {
            /*
                Reload means we're reloading all items, so mark all thumbnails
                dirty and reload the collection view.
            */
            documents = results
            thumbnailCache.markThumbnailCacheDirty()
            collectionView?.reloadData()
        }
        else {
            var indexPathsNeedingReload = [IndexPath]()
            
            let collectionView = self.collectionView!

            collectionView.performBatchUpdates({
                /*
                    Perform all animations, and invalidate the thumbnail cache 
                    where necessary.
                */
                indexPathsNeedingReload = self.processAnimations(animations, oldResults: self.documents, newResults: results, section: DocumentBrowserController.documentsSection)

                // Save the new results.
                self.documents = results
            }, completion: { success in
                if success {
                    collectionView.reloadItems(at: indexPathsNeedingReload)
                }
            })
        }
    }

    // MARK: - RecentModelObjectsManagerDelegate
    
    func recentsManagerResultsDidChange(_ results: [RecentModelObject], animations: [DocumentBrowserAnimation]) {
        if animations == [.reload] {
            recents = results
            
            let indexSet = IndexSet(integer: DocumentBrowserController.recentsSection)

            collectionView?.reloadSections(indexSet)
        }
        else {
            var indexPathsNeedingReload = [IndexPath]()

            let collectionView = self.collectionView!
            collectionView.performBatchUpdates({
                /*
                    Perform all animations, and invalidate the thumbnail cache 
                    where necessary.
                */
                indexPathsNeedingReload = self.processAnimations(animations, oldResults: self.recents, newResults: results, section: DocumentBrowserController.recentsSection)

                // Save the results
                self.recents = results
            }, completion: { success in
                if success {
                    collectionView.reloadItems(at: indexPathsNeedingReload)
                }
            })
        }
    }
    
    // MARK: - Animation Support

    fileprivate func processAnimations<ModelType: ModelObject>(_ animations: [DocumentBrowserAnimation], oldResults: [ModelType], newResults: [ModelType], section: Int) -> [IndexPath] {
        let collectionView = self.collectionView!
        
        var indexPathsNeedingReload = [IndexPath]()
        
        for animation in animations {
            switch animation {
                case .add(let row):
                    collectionView.insertItems(at: [
                        IndexPath(row: row, section: section)
                    ])
                
                case .delete(let row):
                    collectionView.deleteItems(at: [
                        IndexPath(row: row, section: section)
                    ])
                    
                    let URL = oldResults[row].URL
                    self.thumbnailCache.removeThumbnailForURL(URL)
                    
                case .move(let from, let to):
                    let fromIndexPath = IndexPath(row: from, section: section)
                    
                    let toIndexPath = IndexPath(row: to, section: section)
                    
                    collectionView.moveItem(at: fromIndexPath, to: toIndexPath)
                
                case .update(let row):
                    indexPathsNeedingReload += [
                        IndexPath(row: row, section: section)
                    ]
                    
                    let URL = newResults[row].URL
                    self.thumbnailCache.markThumbnailDirtyForURL(URL)
                    
                case .reload:
                    fatalError("Unreachable")
            }
        }
        
        return indexPathsNeedingReload
    }

    // MARK: - ThumbnailCacheDelegateType
    
    func thumbnailCache(_ thumbnailCache: ThumbnailCache, didLoadThumbnailsForURLs URLs: Set<URL>) {
        let documentPaths: [IndexPath] = URLs.flatMap { URL in
            guard let matchingDocumentIndex = documents.index(where: { $0.URL as URL == URL }) else { return nil }
            
            return IndexPath(item: matchingDocumentIndex, section: DocumentBrowserController.documentsSection)
        }
        
        let recentPaths: [IndexPath] = URLs.flatMap { URL in
            guard let matchingRecentIndex = recents.index(where: { $0.URL as URL == URL }) else { return nil }
            
            return IndexPath(item: matchingRecentIndex, section: DocumentBrowserController.recentsSection)
        }
        
        self.collectionView!.reloadItems(at: documentPaths + recentPaths)
    }

    // MARK: - Collection View

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == DocumentBrowserController.recentsSection {
            return recents.count
        }

        return documents.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! DocumentCell

        if let document = documentForIndexPath(indexPath) {
            cell.title = document.displayName
            cell.subtitle = document.subtitle
            cell.thumbnail = thumbnailCache.loadThumbnailForURL(document.URL)
        }
        
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "Header", for: indexPath) as! HeaderView

            header.title = (indexPath as NSIndexPath).section == DocumentBrowserController.recentsSection ? "Recently Viewed" : "All Crystals"
            
            return header
        }

        return super.collectionView(collectionView, viewForSupplementaryElementOfKind: kind, at: indexPath)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Locate the selected document and open it.
        if let document = documentForIndexPath(indexPath) {
            openDocumentAtURL(document.URL as URL)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let document = documentForIndexPath(indexPath) {

            let visibleURLs: [URL] = collectionView.indexPathsForVisibleItems.map( { indexPath in
                if let document = documentForIndexPath(indexPath) {
                    return document.URL as URL
                }
                else {
                    return nil
                }
            } ).filter({ $0 != nil }).map{ $0! }

            if !visibleURLs.contains(document.URL as URL) {
                thumbnailCache.cancelThumbnailLoadForURL(document.URL)
            }
        }
    }

    
    // MARK: - Document handling support
        
    fileprivate func documentBrowserModelObjectForURL(_ url: URL) -> DocumentBrowserModelObject? {
        guard let matchingDocumentIndex = documents.index(where: { $0.URL as URL == url }) else { return nil }
        
        return documents[matchingDocumentIndex]
    }

    // MARK: - ファイル全削除で落ちる、それ以外にもクラッシュが多い箇所 -> オプショナル化
    fileprivate func documentForIndexPath(_ indexPath: IndexPath) -> ModelObject? {
        if (indexPath as NSIndexPath).section == DocumentBrowserController.recentsSection {
            let index = (indexPath as NSIndexPath).row
            return index < recents.count ? recents[index] : nil
        }
        else if (indexPath as NSIndexPath).section == DocumentBrowserController.documentsSection {
            let index = (indexPath as NSIndexPath).row
            return index < documents.count ? documents[index] : nil
        }

        fatalError("Unknown section.")
    }
    
    fileprivate func presentCloudDisabledAlert() {
        OperationQueue.main.addOperation {
            let alertController = UIAlertController(title: cloudDisabledAlertTitle, message: cloudDisabledAlertMessage, preferredStyle: .alert)
            
            let alertAction = UIAlertAction(title: cloudDisabledAlertDismiss, style: .default, handler: nil)
            
            alertController.addAction(alertAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
    }

    #if false
    fileprivate func createNewDocumentWithTemplate(_ templateURL: URL) {
        /*
            We don't create a new document on the main queue because the call to
            fileManager.URLForUbiquityContainerIdentifier could potentially block
        */
        coordinationQueue.addOperation {
            let fileManager = FileManager()
            guard let baseURL = fileManager.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents").appendingPathComponent("Untitled") else {
                
                self.presentCloudDisabledAlert()
                
                return
            }

            var target = baseURL.appendingPathExtension(DocumentBrowserController.documentExtension)
            
            /*
                We will append this value to our name until we find a path that
                doesn't exist.
            */
            var nameSuffix = 2
            
            /*
                Find a suitable filename that doesn't already exist on disk.
                Do not use `fileManager.fileExistsAtPath(target.path!)` because
                the document might not have downloaded yet.
            */
            while (target as NSURL).checkPromisedItemIsReachableAndReturnError(nil) {
                target = URL(fileURLWithPath: baseURL.path + "-\(nameSuffix).\(DocumentBrowserController.documentExtension)")

                nameSuffix += 1
            }
            
            // Coordinate reading on the source path and writing on the destination path to copy.
            let readIntent = NSFileAccessIntent.readingIntent(with: templateURL, options: [])

            let writeIntent = NSFileAccessIntent.writingIntent(with: target, options: .forReplacing)
            
            NSFileCoordinator().coordinate(with: [readIntent, writeIntent], queue: self.coordinationQueue) { error in
                if error != nil {
                    return
                }
                
                do {
                    try fileManager.copyItem(at: readIntent.url, to: writeIntent.url)
                    
                    try (writeIntent.url as NSURL).setResourceValue(true, forKey: URLResourceKey.hasHiddenExtensionKey)
                    
                    OperationQueue.main.addOperation {
                        self.openDocumentAtURL(writeIntent.url)
                    }
                }
                catch {
                    fatalError("Unexpected error during trivial file operations: \(error)")
                }
            }
        }
    }
    #endif

    // MARK: - Document Opening
    
    func documentWasOpenedSuccessfullyAtURL(_ URL: Foundation.URL) {
        recentsManager.addURLToRecents(URL)
    }

    let openLock = NSLock()

//    var sceneViewController: ViewController?

    func openDocumentAtURL(_ url: URL) {
        // Push a view controller which will manage editing the document.
        let controller = storyboard!.instantiateViewController(withIdentifier: "SceneViewController") as! ViewController
        controller.documentURL = url
        show(controller, sender: self)
    }

    func openDocumentAtURL(_ url: URL, copyBeforeOpening: Bool) {
        if copyBeforeOpening  {
            // Duplicate the document and open it.
//            createNewDocumentWithTemplate(url)
            debugPrint("> copy before opening")
            copyDocument( of: url, andOpen: true, andRemove: false )
        }
        else {
            _ = navigationController?.popToRootViewController(animated: false)
            openDocumentAtURL(url)
        }
    }

    func openDocumentAtURL_afterCopy(_ url: URL) {
        if openLock.try() {
            debugPrint("-- copyDocument and Open OK --")
            openDocumentAtURL( url )
        } else {
            debugPrint("-- copyDocument and Open NG --")
        }
    }

    func closeDocument() {
        debugPrint("closeDocument")
        openLock.try()
        openLock.unlock()
    }

    let defaulsKey = AppDelegateDefaultsSampleCopiedKey
    let ubiquitousKey = ubiquitousSampleCopiedKey
}

let AppDelegateDefaultsSampleCopiedKey = "SampleCopiedKey"
private let ubiquitousSampleCopiedKey = "sampleCopiedKey"
private let deviceFileMigrationKey = "deviceFileMigrationKey"

private let stringTableName = "DocumentBrowserController"
private let cloudDisabledAlertTitle = NSLocalizedString( "cloudDisabledAlertTitle",
                                                         tableName: stringTableName,
                                                         bundle: Bundle.main,
                                                         value: "iCloud is disabled",
                                                         comment: "")
private let cloudDisabledAlertMessage = NSLocalizedString( "cloudDisabledAlertMessage",
                                                         tableName: stringTableName,
                                                         bundle: Bundle.main,
                                                         value: "Please enable iCloud Drive in Settings to use this app",
                                                         comment: "")
private let cloudDisabledAlertDismiss = NSLocalizedString( "cloudDisabledAlertDismiss",
                                                           tableName: stringTableName,
                                                           bundle: Bundle.main,
                                                           value: "Dismiss",
                                                           comment: "")

extension DocumentBrowserController {

    func copyDeviceFiles() {
        _ = deviceCIFURLs().map{ copyDocument( of: $0, andOpen: false, andRemove: true ) }
    }

    func copySampleFiles() {
        let urls = ["13MEMS","H2O-Ice","CaCuO2"].map{
            Bundle.main.url(forResource: $0, withExtension: DocumentBrowserController.documentExtension)!
        }
        _ = urls.map{
            copyDocument( of: $0, andOpen:false, andRemove: false )
        }
    }

    func copyDeviceFilesIfNeeds() {
        let flag = UserDefaults.standard.bool(forKey: deviceFileMigrationKey)
        if flag { return }
        UserDefaults.standard.set(true, forKey: deviceFileMigrationKey)
        UserDefaults.standard.synchronize()
        copyDeviceFiles()
    }

    func copySampleFilesIfNeeds__() {
        let flag = UserDefaults.standard.bool(forKey: defaulsKey)
        if flag {
            NSUbiquitousKeyValueStore.default().set(true, forKey: ubiquitousKey)
            NSUbiquitousKeyValueStore.default().synchronize()
            return
        }
        copySampleFiles()
        UserDefaults.standard.set(true, forKey: defaulsKey)
        UserDefaults.standard.synchronize()
    }

    func copySampleFilesIfNeeds() {

        NSUbiquitousKeyValueStore.default().synchronize()
        debugPrint("NSUbiquitousKeyValueStore(0) : \(NSUbiquitousKeyValueStore.default().dictionaryRepresentation)")
        if NSUbiquitousKeyValueStore.default().bool(forKey: ubiquitousKey) == false {
            copySampleFilesIfNeeds__()
            debugPrint("NSUbiquitousKeyValueStore(1) : \(NSUbiquitousKeyValueStore.default().dictionaryRepresentation)")
        }
    }

    @IBAction func gotoSettingApp(_ sender: AnyObject) {
        UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
    }

    @IBAction func deviceRootViewController(_ sender: UIBarButtonItem) {
        let controller = storyboard!.instantiateViewController(withIdentifier: "deviceRootViewController") as! TableViewController
        show(controller, sender: self)
    }

    func copyDocument( of templateURL: URL, andOpen needsOpenFile: Bool, andRemove needsRemoveFile: Bool ) {
        /*
         We don't create a new document on the main queue because the call to
         fileManager.URLForUbiquityContainerIdentifier could potentially block
         */

        //        let path = templateURL.path as String
        let title = (templateURL.lastPathComponent as NSString).deletingPathExtension

        coordinationQueue.addOperation {
            let fileManager = FileManager()
            guard let baseURL = fileManager.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents").appendingPathComponent(title) else {

                self.presentCloudDisabledAlert()

                return
            }

            var target = baseURL.appendingPathExtension(DocumentBrowserController.documentExtension)

            /*
             We will append this value to our name until we find a path that
             doesn't exist.
             */
            var nameSuffix = 2

            /*
             Find a suitable filename that doesn't already exist on disk.
             Do not use `fileManager.fileExistsAtPath(target.path!)` because
             the document might not have downloaded yet.
             */
            while (target as NSURL).checkPromisedItemIsReachableAndReturnError(nil) {
                target = URL(fileURLWithPath: baseURL.path + "-\(nameSuffix).\(DocumentBrowserController.documentExtension)")

                nameSuffix += 1
            }

            // Coordinate reading on the source path and writing on the destination path to copy.
            let readIntent = NSFileAccessIntent.readingIntent(with: templateURL, options: [])

            let writeIntent = NSFileAccessIntent.writingIntent(with: target, options: .forReplacing)

            NSFileCoordinator().coordinate(with: [readIntent, writeIntent], queue: self.coordinationQueue) { error in
                if error != nil {
                    return
                }

                do {
                    try fileManager.copyItem(at: readIntent.url, to: writeIntent.url)

                    try (writeIntent.url as NSURL).setResourceValue(true, forKey: URLResourceKey.hasHiddenExtensionKey)

                    if needsOpenFile {
                        OperationQueue.main.addOperation {
                            self.openDocumentAtURL_afterCopy(writeIntent.url)
                        }
                    }

                    if needsRemoveFile {
                       try FileManager.default.removeItem(at: templateURL)
                    }
                }
                catch {
                    fatalError("Unexpected error during trivial file operations: \(error)")
                }
            }
        }
    }
    
    
}
