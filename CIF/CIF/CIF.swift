//
//  CIF.swift
//  CIF
//
//  Created by Jun Narumi on 2016/05/25.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import Foundation

struct CIF {
    var data:[CIFData] = []
    var crystal:[Int] = []
    init () {}
    init ( data:[CIFData], crystal:[Int] ) {
        self.data = data
        self.crystal = crystal
    }
    var firstCrystal: CIFData? {
        return crystal.count > 0 ? crystal(0) : nil
    }
    func crystal(_ index:Int) -> CIFData {
        return data[crystal[index]]
    }
    var crystalCount:Int {
        return crystal.count
    }
    subscript(index:Int) -> CIFData {
        return data[crystal[index]]
    }
}

struct CIFData {
    var name: String = "false"
    var items: [CIFItems] = []
    init() {}
}

struct CIFLoop {
    var tags: [String] = []
    var values: [String] = []
}

struct CIFItem {
    var tag: String = ""
    var value: String = ""
}

//////////////////////////////////////

protocol CIFItems : CIFShow,CIFQuery {
}

protocol CIFShow {
    var show: String { get }
}

protocol CIFQuery {
    func queryTest(_ tag:String) -> Bool
    func queryGet(_ tag: String) -> [String]
}

//////////////////////////////////////

extension CIF : CIFShow {
    var show: String {
        let str = self.data.map{$0.show}.joined(separator: ",")
        return ["<CIF> -> ",str].joined(separator: " ");
    }
}

extension CIFData : CIFShow {
    
    var show: String {
        let str = items.map{$0.show}.joined(separator: "")
        return ["<data_",name,"> -> \n",str].joined(separator: "");
    }

    fileprivate func query(_ tag:String) -> [String] {
        let result = items.filter({$0.queryTest(tag)})
        return result.count > 0 ? result[0].queryGet(tag) : []
    }

    func string(_ tag:String) -> String? {
        let result = query(tag)
        if result.count == 0 {
            return nil
        }
        return result[0] == "?" ? nil : result[0]
    }

    fileprivate func floatType(_ tag:String) -> FloatType? {
        let str = string(tag)
        return str != nil ? str?.floatTypeValue : nil
    }

    #if false
    private func firstString( tags: [String] ) -> String? {
        for tag in tags {
            if let str = string(tag) {
                return str
            }
        }
        return nil
    }

    private func loopQuery( tags: [String], mainTag: String? ) -> [[String:String]] {
        if mainTag != nil && query(mainTag!).count == 0 {
            return []
        }
        var count = 0
        var arrays : [String:[String]] = [:]
        for tag in tags {
            arrays[tag] = query(tag)
            count = max( count, arrays[tag]?.count ?? 0 )
        }
        var result : [[String:String]] = []
        for i in 0 ..< count {
            var dic : [String:String] = [:]
            for tag in tags {
                if let list = arrays[tag] {
                    if list.count > i {
                        dic[tag] = arrays[tag]?[i] ?? nil
                    }
                }
            }
            result.append(dic)
        }
        return result
    }
    #endif

    func floatType<E: RawRepresentable>( _ tag: E ) -> FloatType? where E.RawValue == String {
        return floatType( tag.rawValue )
    }

    func floatType<E: RawRepresentable>( _ tags: [E] ) -> [E:FloatType] where E.RawValue == String {
        var result : [E:FloatType] = [:]
        for tag in tags {
            if let f = floatType(tag) {
                result[tag] = f
            }
        }
        return result
    }

    func string<E: RawRepresentable>( _ tag: E ) -> String? where E.RawValue == String {
        return string(tag.rawValue)
    }

    func string<E: RawRepresentable>( _ tags: [E] ) -> [E:String] where E.RawValue == String {
        var result : [E:String] = [:]
        for tag in tags {
            if let str = string(tag) {
                result[tag] = str
            }
        }
        return result
    }

    func firstString<E: RawRepresentable>( _ tags: [E] ) -> String? where E.RawValue == String {
        for tag in tags {
            if let str = string(tag) {
                return str
            }
        }
        return nil
    }

    fileprivate func query<E: RawRepresentable>(_ tag:E) -> [String] where E.RawValue == String {
        return query( tag.rawValue )
    }

    func loopQuery<E: RawRepresentable>( _ tags: [E], mainTag: E? ) -> [[E:String]] where E.RawValue == String {
        if mainTag != nil && query(mainTag!.rawValue).count == 0 {
            return []
        }
        var count = 0
        var arrays : [E:[String]] = [:]
        for tag in tags {
            arrays[tag] = query(tag)
            count = max( count, arrays[tag]?.count ?? 0 )
        }
        var result : [[E:String]] = []
        for i in 0 ..< count {
            var dic : [E:String] = [:]
            for tag in tags {
                if let list = arrays[tag] {
                    if list.count > i {
                        dic[tag] = arrays[tag]?[i] ?? nil
                    }
                }
            }
            result.append(dic)
        }
        return result
    }
}


extension CIFLoop : CIFItems {
    var show: String {
        let tagstr = tags.joined(separator: "| -> |")
        let valstr = values.joined(separator: ") -> (");
        return ["\n<loop_> -> |",tagstr,"| -> (",valstr,")\n"].joined(separator: "")
    }
    func queryTest(_ tag:String) -> Bool {
        for aTag in tags {
            if ( tag == aTag ) {
                return true
            }
        }
        return false
    }
    func queryGet(_ tag: String) -> [String] {
        var pos : Int = -1
        for i in 0...(tags.count-1) {
            if ( self.tags[i] == tag ) {
                pos = i
            }
        }
        if ( pos == -1 ) {
            return []
        }
        var values : [String] = []
        for i in 0...(self.values.count-1) {
            if ( i % tags.count == pos )
            {
                values.append(self.values[i])
            }
        }
        return values
    }
}

extension CIFItem : CIFItems {
    var show: String {
        return ["<item> -> |",self.tag,"| -> (",self.value,")\n"].joined(separator: "")
    }
    func queryTest( _ tag: String ) -> Bool {
        return self.tag == tag
    }
    func queryGet( _ tag: String ) -> [String] {
        assert( self.tag == tag );
        return [value]
    }
}











