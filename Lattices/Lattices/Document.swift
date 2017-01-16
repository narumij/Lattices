//
//  Document.swift
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/06/07.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import SceneKit



class Document: UIDocument {

    var rawData: Data!
    var crystal: SwiftCrystal!

    var loadSuccess: Bool = false

    deinit {
        debugPrint("deinit \(self)")
    }

    /*
    func loadFileURL() {
        do {
            try read(from: fileURL)
            removeDataFileIfNeeds()
        } catch {
        }
    }
 */

    override func read( from url: URL) throws {
        rawData = try Data(contentsOf:url)
//        assert(rawData != nil)
//        assert(rawData.count != 0)
        if crystal == nil { crystal = SwiftCrystal() }
        readPersisted()
        applyPersisted0()
        try crystal.read( url: url, ofType: "" )
        applyPersisted2()
        crystal.updateScene()
        crystal.updateBondingRangeMode()
        applyPersisted1()
        removeDataFileIfNeeds()
        updateChangeCount(.done)
    }

    func title() -> String {
        return (Document.nameOf(fileURL) as NSString).deletingPathExtension
    }

    override func contents(forType typeName: String) throws -> Any {
        /*
         Saving the document consists of creating the property list, then
         creating an `NSData` object using plist serialization.
         */
        return rawData
    }

    var fileAttributes: [AnyHashable: Any] = [:]

    override func fileAttributesToWrite(to url: URL, for saveOperation: UIDocumentSaveOperation) throws -> [AnyHashable: Any] {

        if loadSuccess == true {
            writePersist()
//            saveThumnail()
        }

        let aspectRatio = 220.0 / 270.0
        let thumbnailSize = CGSize(width: CGFloat(1024.0 * aspectRatio), height: 1024.0)
        let image = renderThumbnailOfSize(thumbnailSize)
        fileAttributes = [
            URLResourceKey.hasHiddenExtensionKey: true,
            URLResourceKey.thumbnailDictionaryKey: [
                URLThumbnailDictionaryItem.NSThumbnail1024x1024SizeKey: image
            ]
        ]
        debugPrint(fileAttributes)
        return fileAttributes
    }

    override var savingFileType: String? {
        return "jp.zenithgear.cif"
    }

    override func fileNameExtension(forType typeName: String?, saveOperation: UIDocumentSaveOperation) -> String {
        return "cif"
    }
//    var filename: String {
//        let path = fileURL.path!
//        return (path as NSString).lastPathComponent
//    }
//    var name: String {
//        return (filename as NSString).stringByDeletingPathExtension
//    }
//    var dataPath: String? {
//        if let dir = Document.applicationSupportDirectory() {
//            return dir+"/"+name
//        }
//        return nil
//    }

    class func nameOf( _ url: URL ) -> String {
        let path = url.path
        let filename = (path as NSString).lastPathComponent
        let name = (filename as NSString).deletingPathExtension
        return name
    }

    class func dataPath(_ url:URL) -> String? {
        if let dir = Document.applicationSupportDirectory() {
            return dir+"/"+nameOf(url)
        }
        return nil
    }

    class func thumbnailDirectory() -> String? {
        let path = cacheDirectory()
        if let path = path {
            return path + "/Thumbnails"
        }
        return nil
    }

    class func thumnailPath( name:String ) -> String {
        if let dir = Document.thumbnailDirectory() {
            return dir+"/"+name+".png"
        }
        return ""
    }

    class func thumnailPath( _ url:URL ) -> String {
            return thumnailPath(name: nameOf(url))
    }

    class func applicationSupportDirectory() -> String? {
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.applicationSupportDirectory,
                                                       FileManager.SearchPathDomainMask.userDomainMask, true)
        return path.count > 0 ? path.first : nil
    }

    class func cacheDirectory() -> String? {
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory,
                                                       FileManager.SearchPathDomainMask.userDomainMask, true)
        return path.count > 0 ? path.first : nil
    }

    func prepareDataDirectory()
    {
        if let path = Document.applicationSupportDirectory() {
            if FileManager.default.fileExists(atPath: path, isDirectory: nil ) == false {
                do {
                    try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: false, attributes: [:])
                } catch {
                }
            }
        }
    }

    func writePersist() {
        var persist : [String:AnyObject] = [:]
        if Document.loadBondExpansion {
            persist["bondRangeMode"] = crystal.bondingRangeMode.rawValue as AnyObject?
        }
        if Document.loadColorAndRadii {
//            persist["set"] = crystal.radiiFileName
            persist["radiiTypeStr"] = crystal.radiiType.rawValue as AnyObject?
            persist["size"] = crystal.radiiSize as AnyObject?
//            persist["dia"] = crystal.bondDiameter
            persist["bsize"] = crystal.bondSize as AnyObject?
        }
        if Document.loadCamera {
            persist["position"] = NSValue( scnVector3: crystal.camera.rig.position )
            persist["orientation"] = NSValue( scnVector4: crystal.camera.rig.orientation )
            persist["scale"] = crystal.camera.rig.orthographicScale as AnyObject?
            persist["useOrth"] = crystal.camera.rig.usesOrthographicProjection as AnyObject?
        }
        if true {
            persist["groups"] = crystal.prime.bondGroups.map({
                return NSDictionary(dictionary: dictionaryRepresentation( from: $0 ) )
            }) as AnyObject
        }

        persist["latticeHidden"] = crystal.latticeHidden as AnyObject?

        if let dataPath = Document.dataPath(fileURL) {
            prepareDataDirectory()
//            let result = NSKeyedArchiver.archiveRootObject( persist, toFile: dataPath )
//            debugPrint("save result : \(result) \(persist)")
            debugPrint("save date   : \(NSDate())")
        }
    }

    static var initialAnimationDuration : CFTimeInterval = 1.0
    static var loadColorAndRadii = true
    static var loadCamera = true
    static var loadBondExpansion = false
    static var loadGroupPublFlags = true

    var persisted: [String:AnyObject] = [:]

    func readPersisted() {
        guard let dataPath = Document.dataPath(fileURL) else {
            return
        }
        persisted = NSKeyedUnarchiver.unarchiveObject(withFile: dataPath) as? [String:AnyObject] ?? [:]
    }

    func applyPersisted0() {
        if Document.loadBondExpansion {
            if let bondingRangeMode = persisted["bondRangeMode"] { crystal.bondingRangeMode = SwiftCrystal.BondingRangeMode( rawValue: bondingRangeMode as! String ) ?? .UnitCell }
        }
    }

    func applyPersisted1() {
        if Document.loadColorAndRadii {
//          if let set = persist["set"] { crystal.radiiFileName = set as! String }
            if let radiiType = persisted["radiiTypeStr"] { crystal.radiiType = RadiiType( rawValue: radiiType as! String ) ?? .Calculated }
            if let size = persisted["size"] { crystal.radiiSize = size as! RadiiSizeType }
//          if let dia = persist["dia"] { crystal.bondDiameter = dia as! RadiiSizeType }
            if let bsize = persisted["bsize"] { crystal.bondSize = bsize as! RadiiSizeType }
        }
        if Document.loadCamera {
            if let position = persisted["position"] { crystal.camera.rig.position = (position as! NSValue).scnVector3Value }
            if let orientation = persisted["orientation"] { crystal.camera.rig.orientation = (orientation as! NSValue).scnVector4Value }
            if let scale = persisted["scale"] { crystal.camera.rig.orthographicScale = scale as! Double }
            if let useOrth = persisted["useOrth"] { crystal.camera.rig.usesOrthographicProjection = useOrth as! Bool }
            crystal.camera.refresh()
        }
        if let latticeHidden = persisted["latticeHidden"] { crystal.latticeHidden = latticeHidden as! Bool }
    }

    func applyPersisted2() {
        guard let groups = persisted["groups"] as? [[String:AnyObject]] else {
            return
        }
        if Document.loadGroupPublFlags {
            let groupIndices: [(publFlag:Bool,anyCode:SiteSymmetryCode_t)] = groups.map{
                primeAtomGroupIndex(from: $0)
            }
//            debugPrint(crystal.prime.bondGroups)
            _ = groupIndices.map({
                (index) in
                crystal.prime
                    .bondGroups
                    .filter({ index.anyCode.primeAtomBondGroupCondition($0) })
                    .map({
                        $0.publFlag = index.publFlag
                    })
            })
        }
    }

    class func removeCIFFile( _ cif: URL ) {
        assert(false, "prohibited method")
        do {
            try FileManager.default.removeItem(at: cif)
        } catch {
        }
    }

    class func removeDataFile( _ cif: URL ) {
        if let dataPath = Document.dataPath(cif) {
            if FileManager.default.fileExists(atPath: dataPath)
            {
                do {
                    try FileManager.default.removeItem(atPath: dataPath)
                    debugPrint("do remove data \(dataPath)")
                } catch {
                }
            }
        }
    }

    class func removeThumbnail( _ cif: URL ) {
        let dataPath = Document.thumnailPath(cif)
        if FileManager.default.fileExists(atPath: dataPath)
        {
            do {
                try FileManager.default.removeItem(atPath: dataPath)
                debugPrint("do remove thumbnail \(dataPath)")
            } catch {
            }
        }
    }

    func removeDataFileIfNeeds() {
        if ( Document.loadColorAndRadii || Document.loadCamera ) == false {
            Document.removeDataFile(fileURL)
        }
    }

    func prepareThumnailDirectory()
    {
        if let path = Document.thumbnailDirectory() {
            if FileManager.default.fileExists(atPath: path, isDirectory: nil ) == false {
                do {
                    try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: false, attributes: [:])
                } catch {
                }
            }
        }
    }

    static let DidSaveThumnailNotification = "DocumentDidSaveThumnailNotification"

    func saveThumnail(thumbnail image:UIImage) {
        prepareThumnailDirectory()
        let thumbnailPath = Document.thumnailPath(fileURL)
        let result = (try? UIImagePNGRepresentation(image)?.write( to: URL(fileURLWithPath: thumbnailPath), options: [.atomic] )) != nil
        debugPrint("thumbnail save result \(result)")
        NotificationCenter.default
            .post( name: Notification.Name(rawValue: Document.DidSaveThumnailNotification), object: self )
    }

    var animationFinishDate : Date? = Date()

    func saveThumnail() {
        #if true
            if animationFinishDate?.compare(Date()) == .orderedAscending {
                let image = renderThumbnailOfSize( CGSize(width: 1024, height: 1024) )
                saveThumnail(thumbnail: image)
            }
        #elseif true
            if animationFinishDate?.compare(Date()) == .orderedAscending {
                let image = crystal.currentThumnail(CGSize(width: 128, height: 128))
                saveThumnail(thumbnail: image)
            }
        #else
            if let animationFinishDate = animationFinishDate {
                NSRunLoop.currentRunLoop().runUntilDate(animationFinishDate)
            }
            let image = crystal.currentThumnail(CGSizeMake(128, 128))
            saveThumnail(thumbnail: image)
        #endif
    }

    class func thumbnail(name:String) -> UIImage? {
        return thumbnailOrNil(name:name) ?? ColorImage( UIColor(white: 0.95, alpha: 1.0), size: CGSize(width: 128, height: 128) )
    }

    class func thumbnailOrNil(name:String) -> UIImage? {
        let path = thumnailPath(name: (name as NSString).deletingPathExtension )
        return UIImage(contentsOfFile: path)
    }

    func cifString( _ keys : [String] ) -> String? {
        for key in keys {
            if let str = crystal.cifData.firstCrystal?.string(key) {
                return str
            }
        }
        return nil
    }
}


















