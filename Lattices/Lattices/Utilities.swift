//
//  Utilitiies.swift
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/06/08.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import Foundation

let kCIFFileExtension = "cif"

func deviceCIFURLs() -> [URL] {
    return loadFiles()
        .map{ fileURL( $0 )}
}

func loadFiles() -> [String] {
    let directoryFiles = try! FileManager.default.contentsOfDirectory(atPath: documentsDirectory()!)
    return directoryFiles.filter { (s) -> Bool in
        (s as NSString).pathExtension.lowercased() == (kCIFFileExtension as NSString) as String
    }.sorted()
}

func loadFileName( _ name:String ) -> String? {
    return loadFiles().filter({ ($0 as NSString).deletingPathExtension == name }).first
}

//func loadNames() -> [String]
//{
//    return loadFiles().map{ ($0 as NSString).stringByDeletingPathExtension }
//}

func documentsDirectory() -> String? {
    let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory,
                                                   FileManager.SearchPathDomainMask.userDomainMask, true)
    return path.count > 0 ? path.first : nil
}

func temporaryDirectory() -> String? {
    let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory,
                                                   FileManager.SearchPathDomainMask.userDomainMask, true)
    return path.count > 0 ? path.first : nil
}

func fileURL( _ filename: String ) -> URL {
    let directoryPath = documentsDirectory()!
    let filepath = (directoryPath as NSString).appendingPathComponent(filename)
    return URL.init(fileURLWithPath: filepath)
}

func temporaryFileURL( _ filename: String ) -> URL {
    let directoryPath = NSTemporaryDirectory()
    let filepath = (directoryPath as NSString).appendingPathComponent(filename)
    return URL.init(fileURLWithPath: filepath)
}


func loadFile( _ filename: String ) -> Document {
    let directoryPath = documentsDirectory()!
    let filepath = (directoryPath as NSString).appendingPathComponent(filename)
    let url = URL(fileURLWithPath: filepath)
    let doc = Document(fileURL: url)
    try! doc.read(from: url)
    return doc
}

func saveItem( _ fileURL: URL ) -> URL? {
    do {
        let str = try NSString(contentsOf: fileURL, encoding: String.Encoding.utf8.rawValue)
        let filename = (fileURL.path as NSString).lastPathComponent
        let savepath = (documentsDirectory()! + "/") + filename
        try str.write(toFile: savepath, atomically: true, encoding: String.Encoding.utf8.rawValue)
        return URL(fileURLWithPath: savepath)
    } catch {
    }
    return nil
}

func deleteFile( _ filename: String ) {
    do {
        try FileManager.default.removeItem(at: fileURL(filename))
    } catch {
        NSLog("ERROR: File could not be deleted");
    }
}

func removeInboxItem( _ url: URL ) {
    do {
        try FileManager.default.removeItem(at: url)
    } catch {
        NSLog("ERROR: Inbox file could not be deleted");
    }
}

func touchDummy()
{
    #if !NDEBUG
        let dir = NSTemporaryDirectory()
        FileManager.default.createFile(atPath: dir+"/null", contents: nil, attributes: nil)
        debugPrint(dir)
    #endif
}
































