//
//  CIFParser.swift
//  CIF
//
//  Created by Jun Narumi on 2016/05/25.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import Foundation

enum ParseError : Error {
    case wow
}

class CIFParser : NSObject {
    var flag: Bool = true
    var root: RuleCIF = RuleCIF()
    var result: CIF { return root.result as! CIF }
    var errorlineno: size_t = -1
    var errorcolumn: size_t = -1
    func parse( _ filepath: String ) throws {
        CIFLexer(filepath, self)
        if flag == false {
            throw ParseError.wow
        }
    }
    func parseWithFILE( _ filehandle: UnsafeMutablePointer<FILE> ) throws {
        CIFLexerWithFILE(filehandle, self)
        if flag == false {
            throw ParseError.wow
        }
    }
    func nextLexeme( _ scanner: UnsafeMutableRawPointer, tag: CIFLexemeTag, text: String ) {
        let result = root.accept( scanner, tag, text )
        if flag == true && result == false {
            errorlineno = CIFLine(scanner);
            errorcolumn = CIFColumn(scanner);
        }
        flag = flag && result
    }
}

///////////////////////////////////

class ParseRule {
    var result: Any { return () }
    var current: ParseRule? = nil
    func accept( _ scanner: UnsafeMutableRawPointer,_ tag: CIFLexemeTag,_ text: String ) -> Bool {
        return false
    }
    func log(_ str:String) {
//        print(str)
    }
    func log1(_ str:String) {
//        print(str)
    }
}

class RuleCIF : ParseRule {
    // dataを受け付けて、dataを開始する
    var data: [CIFData] = []
    var crystal: [Int] = []

    func append() {
        if let d = (current?.result as? CIFData) {
            if d.string("_cell_length_a") != nil {
                crystal.append(data.count)
            }
            data.append(d)
        }
//        current = nil
    }

    override var result: Any {
        if current != nil {
            append()
        }
        return current != nil ? CIF( data: data, crystal: crystal  ) : CIF()
    }

    override func accept( _ scanner: UnsafeMutableRawPointer,_ tag: CIFLexemeTag,_ text: String ) -> Bool {
        if ( current?.accept( scanner, tag, text ) ?? false )
        {
            return true
        }
        if tag == LData_ {
            if current != nil {
                append()
            }
            log(">>>>> Begin CIF <<" + data.count.description + ">>")
            current = RuleData()
            return true
        }
        if tag == LTag {
            current = RuleData()
            _ = current?.accept( scanner, tag, text )
            return true
        }
        if tag == LEOF {
            append()
            log("<<<<< End CIF! <<" + data.count.description + ">>")
            return true
        }
        print( "** Parse Error " + CIFLexemeTagName(tag) + " " + text )
        // error
        return false
    }
}

class RuleData : ParseRule {
    // dataを最初に受け付けて、loopが来たらloopsに処理を渡す、あるいはtagがきたらitemに処理を渡す。そしてdataが来るまでループする
    var item: CIFData = CIFData()
    override var result: Any {
        return item
    }
    override func accept( _ scanner: UnsafeMutableRawPointer,_ tag: CIFLexemeTag,_ text: String ) -> Bool {
        var flag = false
        if let c = current {
            if c.accept( scanner, tag, text) == true {
                return true
            } else {
                if current?.result is CIFLoop {
                    item.items.append(current?.result as! CIFLoop)
                }
                if current?.result is CIFItem {
                    item.items.append(current?.result as! CIFItem)
                }
                log( "Pop Data [ln:" + CIFLine(scanner).description + " col:" + CIFColumn(scanner).description + "]" + ( item.items.last?.show ?? "" ) )
                log( "items count ( " + item.items.count.description + " )" )
                current = nil
                flag = tag != LEOF
            }
        }
        let test: [ParseRule] = [RuleLoop(),RuleItem()].filter({ $0.accept( scanner, tag, text) })
        if ( test.count == 1 )
        {
            item.name = text
            log("Push Data ")
            current = test[0]
            return true
        }
        // parse error
        return flag
    }
}

func isTag(_ tag:CIFLexemeTag) -> Bool {
    return tag == LTag
}

func isValue(_ tag:CIFLexemeTag) -> Bool {
    return [LNumeric,LQuoteString,LUnquoteString,LTextField,LDot,LQue].filter({$0==tag}).count == 1
}

class RuleLoop : ParseRule {
    // loopを最初に受け付けて、tagsに処理を渡し、戻ったらvaluesに処理を渡し、戻ったら終了する
    var mode: Int = 0
    var item: CIFLoop = CIFLoop()
    override var result: Any {
        return item
    }
    override func accept( _ scanner: UnsafeMutableRawPointer,_ tag: CIFLexemeTag,_ text: String) -> Bool {
        if mode == 0 && tag == LLoop_ {
            log1( "Start Loop Tags" + " " + text )
            mode = 1
            return true
        }
        if mode == 1 && isTag(tag) {
            log1( "Tag " + " " + text )
            item.tags.append(text)
            return true
        }
        if mode == 1 && isValue(tag) {
            log1( "Start Loop Values")
            mode = 2
        }
        if mode == 2 && isValue(tag) {
            log1( "Value " + text )
            item.values.append(text)
            return true
        }
        if mode == 2 {
            log1( "End Loop " + CIFLexemeTagName(tag) + " " + text )
            return false
        }
        return false
    }
}

class RuleItem : ParseRule {
    // tagを最初に受け付けて、valueを貰うと終了する
    var mode: Int = 0
    var item: CIFItem = CIFItem()
    override var result: Any {
        return item
    }
    override func accept( _ scanner: UnsafeMutableRawPointer,_ tag: CIFLexemeTag,_ text: String) -> Bool {
        if mode == 0 && isTag( tag ) {
            log1( "Item tag  " + " " + text )
            item.tag = text
            mode = 1
            return true
        }
        else if isValue( tag ) {
            log1( "Item value " + " " + text )
            item.value = text
            mode = 2
            return false
        }
        return false
    }
}





