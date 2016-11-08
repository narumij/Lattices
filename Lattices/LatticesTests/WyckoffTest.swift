//
//  WyckoffTest.swift
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/09/11.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import XCTest

extension LatticesTests {
    func testWyckoff0() {
        let hoge: [(String,WyckoffDetectorKind,[((FloatType,FloatType,FloatType),Bool)])] =
            [
                ("1/2,1/2,1/2",.point,
                    [
                        ((0.5,0.5,0.5),true),
                        ((0,0.5,0.5),false),
                        ((1,1,1),false),
                    ]),
                ("0,0,0",.point,
                    [
                        ((0,0,0),true),
                        ((0,0.5,0.5),false),
                        ((0.01,0,0),false),
                    ]),
                ("x,0,0",.line,
                    [
                        ((1,0,0),true),
                        ((0.5,0,0),true)
                    ]),
                ("y,y,0",.line,
                    [
                        ((0.1,0.1,0),true),
                        ((0.2,0.2,0),true),
                        ((0.5,0.5,0),true),
                        ((1,1,0),true),
                    ]),
                ("z,0,-z",.line,
                    [
                        ((0.9,0,-0.9),true),
                        ((0.2,0,-0.2),true),
                        ((0.5,0,-0.5),true),
                        ((1,0,-1),true),
                        ((1,0,0),false),
                    ]),
                ("x,y,0",.plane,
                    [
                        ((0,0,0),true),
                        ((0.2,0,0),true),
                        ((0.2,0.2,0),true),
                        ((0,0.2,0),true),
                        ((0,0.2,0.1),false)
                    ]),
                ("x,y,x",.plane,
                    [
                        ((0,0,0),true),
                        ((0.2,0,0.2),true),
                        ((0.2,0.2,0.2),true),
                        ((0,0.2,0),true),
                        ((0,0.2,0.1),false)
                    ]),
                ("x,y,-x",.plane,
                    [
                        ((0,0,0),true),
                        ((0.2,0,-0.2),true),
                        ((0.2,0.2,-0.2),true),
                        ((0,0.2,0),true),
                        ((0,0.2,0.1),false)
                    ])
        ]
        _ = hoge.map{
            let wd = WyckoffPositionMake(matrix:XYZParse($0.0))
            XCTAssert( wd.kind == $0.1 )
            _ = $0.2.map{
                let v = Vector3($0.0.0,$0.0.1,$0.0.2)
                XCTAssertTrue( wd.isEquiv(v) == $0.1 )
            }
        }
    }
    func testWyckoff1() {
        let hoge: [(String,WyckoffDetectorKind,[((FloatType,FloatType,FloatType),Bool)])] =
            [
                ("1/2,1/2,1/2",.point,
                    [
                        ((0.5,0.5,0.5),true),
                        ((0,0.5,0.5),false),
                        ((1,1,1),false),
                    ]),
                ("0,0,0",.point,
                    [
                        ((0,0,0),true),
                        ((0,0.5,0.5),false),
                        ((0.01,0,0),false),
                    ]),
                ("x,0,0",.line,
                    [
                        ((1,0,0),true),
                        ((0.5,0,0),true)
                    ]),
                ("y,y,0",.line,
                    [
                        ((0.1,0.1,0),true),
                        ((0.2,0.2,0),true),
                        ((0.5,0.5,0),true),
                        ((1,1,0),true),
                    ]),
                ("z,0,-z",.line,
                    [
                        ((0.9,0,-0.9),true),
                        ((0.2,0,-0.2),true),
                        ((0.5,0,-0.5),true),
                        ((1,0,-1),true),
                        ((1,0,0),true),
                        ((0.9,0,0.1),true),
                        ((0.8,0,0.2),true),
                        ((0.6,0,0.4),true),
                        ((0.4,0,0.6),true),
                        ((0.2,0,0.8),true),
                    ]),
                ("x,y,0",.plane,
                    [
                        ((0,0,0),true),
                        ((0.2,0,0),true),
                        ((0.2,0.2,0),true),
                        ((0,0.2,0),true),
                        ((0,0.2,0.1),false)
                    ]),
                ("x,y,x",.plane,
                    [
                        ((0,0,0),true),
                        ((0.2,0,0.2),true),
                        ((0.2,0.2,0.2),true),
                        ((0,0.2,0),true),
                        ((0,0.2,0.1),false)
                    ]),
                ("x,y,-x",.plane,
                    [
                        ((0,0,0),true),
                        ((0.2,0,-0.2),true),
                        ((0.2,0.2,-0.2),true),
                        ((0,0.2,0),true),
                        ((0.8,0.5,0.8),false),
                        ((0.2,0,0.8),true),
                        ((0.4,0,0.6),true),
                        ((0.6,0,0.4),true),
                    ])
        ]
        _ = hoge.map{
//            debugPrint("\($0.0)")
            let wd = WyckoffPositionMake(matrix:XYZParse($0.0))
            XCTAssert( wd.kind == $0.1 )
            _ = $0.2.map{
                let v = Vector3($0.0.0,$0.0.1,$0.0.2)
//                debugPrint("\(v)")
                XCTAssertTrue( wd.isTorelant(v) == $0.1 )
            }
        }
    }
//    func testWyckoffPositions() {
//
//        let honge = hoge( wyckoffData[ SG(185,1) ]!, symop: fromIndex(185, 1) )
//
//    }
}
