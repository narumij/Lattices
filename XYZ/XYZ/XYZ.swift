//
//  XYZ.swift
//  XYZ
//
//  Created by Jun Narumi on 2016/05/26.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import SceneKit

#if os(OSX)
    typealias SymopType = Double
#elseif os(iOS)
    typealias SymopType = Float
#endif

typealias SymopEquivType = (
    (SymopType,SymopType,SymopType,SymopType),
    (SymopType,SymopType,SymopType,SymopType),
    (SymopType,SymopType,SymopType,SymopType))

enum XYZLexeme {
    case null
    case flt
    case uint
    case plus
    case minus
    case x
    case y
    case z
    case comma
    case rat
    case eol
    case error
}

struct Regex {
    let regex: NSRegularExpression
    init(_ pattern: String) {
        self.regex = try! NSRegularExpression( pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
    }
    func isMatch(_ input: String) -> Bool {
        let inputRange = NSRange(location: 0, length: input.count)
        return self.regex.numberOfMatches( in: input, options: [], range: inputRange) > 0
    }
    func lengthOfFirstMatch(_ input: String) -> Int {
        let inputRange = NSRange(location: 0, length: input.count)
        let range = self.regex.rangeOfFirstMatch( in: input, options: [], range: inputRange)
        return range.length;
    }
    func firstMatch(_ input: String) -> String {
        let inputRange = NSRange(location: 0, length: input.count)
        let match = self.regex.firstMatch( in: input, options: [], range: inputRange )
        return (input as NSString).substring(with: match!.range)
    }
}

struct XYZLexerRule {
    var reg: Regex
    var action: (String)->Void
    init( reg: Regex, action: @escaping (String)->Void )
    {
        self.reg = reg
        self.action = action
    }
}

let float = "^(([0-9]+([eE])|([eE][+-])[0-9]+)|(([0-9]*\\.[0-9]+)|([0-9]\\.)(([eE])|([eE][+-])[0-9]+)?))"

func xyzlex(_ str:String,token:@escaping (XYZLexeme,SymopType)->())
{
    let rules: [XYZLexerRule] = [
        XYZLexerRule( reg: Regex("^[:blank:]"), action: {(_)in} ),
        XYZLexerRule( reg: Regex(float), action: { token(XYZLexeme.flt,SymopType(atof($0))) } ),
        XYZLexerRule( reg: Regex("^[0-9]+"), action: { token(XYZLexeme.uint,SymopType(atof($0))) } ),
        XYZLexerRule( reg: Regex("^\\+"), action: { _ in token(XYZLexeme.plus,1) } ),
        XYZLexerRule( reg: Regex("^-"), action: { _ in  token(XYZLexeme.minus,-1) } ),
        XYZLexerRule( reg: Regex("^[xX]"), action: { _ in  token(XYZLexeme.x,0) } ),
        XYZLexerRule( reg: Regex("^[yY]"), action: { _ in  token(XYZLexeme.y,0) } ),
        XYZLexerRule( reg: Regex("^[zZ]"), action: { _ in  token(XYZLexeme.z,0) } ),
        XYZLexerRule( reg: Regex("^,"), action: { _ in  token(XYZLexeme.comma,0) } ),
        XYZLexerRule( reg: Regex("^/"), action: { _ in  token(XYZLexeme.rat,0) } ),
        XYZLexerRule( reg: Regex("."), action:  { _ in  token(XYZLexeme.error,0) } ),
        ]

    var idx = str.startIndex
    while idx != str.endIndex {
        let subStr = str.substring(from: idx)
        for rule in rules {
            if rule.reg.isMatch(subStr) {
                let len = rule.reg.lengthOfFirstMatch(subStr)
//                idx = subStr.index(idx, offsetBy: len)
//                idx = idx + len
                idx = str.index(idx, offsetBy: len)

//                print( "match -> " + rule.reg.firstMatch(subStr)+" >> " + len.description )
                rule.action(rule.reg.firstMatch(subStr))
                break
            }
        }
    }
    token(XYZLexeme.eol,0)
//    print("-----------------")
}

class XYZParser {

    let null = XYZLexeme.null
    var stack : [(XYZLexeme,SymopType)] = []
    var stackValid = true
    var number : SymopType = 0
    var sign : SymopType = 1
    var x : SymopType = 0
    var y : SymopType = 0
    var z : SymopType = 0
    var w : SymopType = 0
    var rows : [[SymopType]] = []

    init() { }

    func log(_ str:String) {
//        print(str)
    }

    func accept( _ lexeme: XYZLexeme,_ num: SymopType ) {
        let val = sign * number
        switch lexeme {
        case XYZLexeme.x:
            log("x")
            x = sign * (number == 0 ? 1 : number)
            nextTerm()
            return
        case XYZLexeme.y:
            log("y")
            y = sign * (number == 0 ? 1 : number)
            nextTerm()
            return
        case XYZLexeme.z:
            log("z")
            z = sign * (number == 0 ? 1 : number)
            nextTerm()
            return
        case XYZLexeme.minus:
            log("-")
            w = val == 0 ? w : val
            nextTerm()
            sign = -1
            return
        case XYZLexeme.plus:
            log("+")
            w = val == 0 ? w : val
            nextTerm()
            return
        case XYZLexeme.comma:
            log(",")
            fallthrough
        case XYZLexeme.eol:
            log("EOL")
            w = val == 0 ? w : val
            nextTerm()
            nextRow()
            return
        default:
            break;
        }

        stack.append((lexeme,num))

        log("stack"+stack.description)
        switch tup {
        case (XYZLexeme.uint,XYZLexeme.rat,XYZLexeme.uint):
            log("rat")
            number = stack[0].1 / stack[2].1
            stackValid = true
        case (XYZLexeme.flt,null,null):
            log("flt")
            number = stack[0].1
            stackValid = true
        case (XYZLexeme.uint,null,null):
            log("int")
            number = stack[0].1
            stackValid = true
        default:
            stackValid = false
        }
    }

    var tup : (XYZLexeme,XYZLexeme,XYZLexeme) {
        switch stack.count {
        case 1:
            return (stack[0].0,null,null)
        case 2:
            return (stack[0].0,stack[1].0,null)
        case 3:
            return (stack[0].0,stack[1].0,stack[2].0)
        default:
            return (null,null,null)
        }
    }

    func nextTerm()
    {
        if stackValid == false {
            print("** error about numeric")
        }
        stackValid = true
        number = 0
        sign = 1
        stack = []
    }

    func nextRow()
    {
        rows.append([x,y,z,w])
        x = 0
        y = 0
        z = 0
        w = 0
    }

}

func XYZParse__(_ str:String) -> [[SymopType]]
{
    let parser = XYZParser()
    xyzlex(str){ parser.accept( $0.0, $0.1 ) }
    return parser.rows
}













