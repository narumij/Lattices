//
//  main.swift
//  XYZ
//
//  Created by Jun Narumi on 2016/05/26.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import Foundation

print("Hello, World!")

func p(lexeme:XYZLexeme,_ token:Double) -> Void {
    var type = ""
    switch lexeme {
    case XYZLexeme.flt:
        type = "FLT"
    case XYZLexeme.uint:
        type = "UINT"
    case XYZLexeme.plus:
        type = "PLUS"
    case XYZLexeme.minus:
        type = "MINUS"
    case XYZLexeme.x:
        type = "X"
    case XYZLexeme.y:
        type = "Y"
    case XYZLexeme.z:
        type = "Z"
    case XYZLexeme.comma:
        type = "COMMA"
    case XYZLexeme.rat:
        type = "RAT"
    case XYZLexeme.eol:
        type = "EOL"
    case XYZLexeme.error:
        type = "Error"
    default:
        break;
    }
    print( "token( " + type + " " + token.description + " )" )
}

//xyzlex("x,y,z",token:p)
//xyzlex("-x+1/2,y-x,-z+y",token:p)

func p(_ d:[[Double]]) {
    for row in d {
        print(row.description)
    }
}

func Parse(_ str:String)
{
    print( str )
    p( XYZParse__(str) )
}

Parse("x,y,z")
Parse("-x+1/2,y-x,-z+y")
Parse("x,y,z")
Parse("2x+1/2,-y,0")
Parse("22x,0,1/2")
Parse("2x+1/2,-y+2/3,-z")
Parse("1/2x,0,0")
Parse("0,y,0")
Parse("0,2y,0")
Parse("0,22y,0")
Parse("0,1/2y,0")
Parse("1,0,0")
Parse("11,0,0")
Parse("0.5,0,0")
Parse("2/3,0,0")
Parse("1/2+x,1/2+y,1/2+z")
Parse("1.0x,0,0")
Parse("0,0,1.0z")
Parse("0,1.0y,0")
Parse("-x,-y,-z")

print(Regex.init(float).isMatch("1.0"))





