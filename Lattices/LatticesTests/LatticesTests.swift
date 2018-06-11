//
//  LatticesTests.swift
//  LatticesTests
//
//  Created by Jun Narumi on 2016/07/26.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import XCTest
import SceneKit

class LatticesTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.


    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}

extension LatticesTests {

//    func testMatrix() {
//        let m = SCNMatrix4(m11: 11, m12: 12, m13: 13, m14: 14,
//                           m21: 21, m22: 22, m23: 23, m24: 24,
//                           m31: 31, m32: 32, m33: 33, m34: 34,
//                           m41: 41, m42: 42, m43: 43, m44: 44)
//        XCTAssert(m[1,1] == 11)
//        XCTAssert(m[1,2] == 12)
//    }

    func testSymmetryMatrix() {
        let hoge = [("x,y,z",Matrix3x3Identity,Vector3Zero),
                    ("1/2,1/3,1/4",Matrix3x3(0),Vector3(0.5,0.3333333,0.25))]
        _ = hoge.map{
            let m = XYZParse($0.0)
            XCTAssert(m.rotatePart == $0.1)
            XCTAssert(m.translatePart =~~ $0.2)
        }
    }
    func testCellAngle() {
        let cell = CrystalCell_t(a:1,b:1,c:1,alpha:90,beta:90,gamma:90)
        let v0 = Vector3(1,0,0)
        let v1 = normalize(Vector3(1,1,0))
        let v2 = Vector3(0,1,0)
        let v3 = Vector3(-1,0,0)
        XCTAssert( cell.angle(v0, apexFract: Vector3Zero, toFract: v2) =~~ FloatType(Float.pi / 2) )
        XCTAssert( cell.angle(v0, apexFract: Vector3Zero, toFract: v1) =~~ FloatType(Float.pi / 4) )
        XCTAssert( cell.angle(v2, apexFract: Vector3Zero, toFract: v1) =~~ FloatType(Float.pi / 4) )
        XCTAssert( cell.angle(v0, apexFract: Vector3Zero, toFract: v3) =~~ FloatType(Float.pi) )
        XCTAssert( cell.angle(v2, apexFract: Vector3Zero, toFract: v3) =~~ FloatType(Float.pi / 2) )
        func t( _ p:(Vector3,Vector3,Vector3) ) -> Bool {
            return angle(p.0,apex:p.1,to:p.2) =~~ cell.angle(p.0,apexFract:p.1,toFract:p.2)
        }
        let r30 = FloatType(30).toRadian
        let r60 = FloatType(60).toRadian
        let v4 = Vector3(sin(r30),cos(r30),0.0)
        let v5 = Vector3(sin(r60),cos(r60),0.0)
        XCTAssert(t((v0,Vector3Zero,v2)))
        XCTAssert(t((v0,Vector3Zero,v4)))
        XCTAssert(t((v4,Vector3Zero,v5)))
        XCTAssert(t((v5,Vector3Zero,v1)))
    }
    func testAngle01() {
        let v0 = Vector3(1,0,0)
        let v1 = Vector3(1,1,0)
        let v2 = Vector3(0,1,0)
        let v3 = Vector3(-1,0,0)
        XCTAssert( angle0(v0, apex: Vector3Zero, to: v2) =~~ angle1(v0, apex: Vector3Zero, to: v2) )
        XCTAssert( angle0(v0, apex: Vector3Zero, to: v1) =~~ angle1(v0, apex: Vector3Zero, to: v1) )
        XCTAssert( angle0(v2, apex: Vector3Zero, to: v1) =~~ angle1(v2, apex: Vector3Zero, to: v1) )
        XCTAssert( angle0(v0, apex: Vector3Zero, to: v3) =~~ angle1(v0, apex: Vector3Zero, to: v3) )
        XCTAssert( angle0(v2, apex: Vector3Zero, to: v3) =~~ angle1(v2, apex: Vector3Zero, to: v3) )
    }
    func testAngle() {
        let v0 = Vector3(1,0,0)
        let v1 = Vector3(1,1,0)
        let v2 = Vector3(0,1,0)
        let v3 = Vector3(-1,0,0)
        XCTAssert( angle(v0, apex: Vector3Zero, to: v2) =~~ FloatType(Float.pi / 2) )
        XCTAssert( angle(v0, apex: Vector3Zero, to: v1) =~~ FloatType(Float.pi / 4) )
        XCTAssert( angle(v2, apex: Vector3Zero, to: v1) =~~ FloatType(Float.pi / 4) )
        XCTAssert( angle(v0, apex: Vector3Zero, to: v3) =~~ FloatType(Float.pi) )
        XCTAssert( angle(v2, apex: Vector3Zero, to: v3) =~~ FloatType(Float.pi / 2) )
    }
    func testSymmetryCode() {
        let test = [
            ("1_555",LatticeCoord(0,0,0),1),
            ("2_444",LatticeCoord(-1,-1,-1),2),
            ("2_455",LatticeCoord(-1,0,0),2),
            ("2_545",LatticeCoord(0,-1,0),2),
            ("2_554",LatticeCoord(0,0,-1),2),
            ("3_666",LatticeCoord(1,1,1),3),
            ("3_655",LatticeCoord(1,0,0),3),
            ("3_565",LatticeCoord(0,1,0),3),
            ("3_556",LatticeCoord(0,0,1),3),
            ("16_455",LatticeCoord(-1,0,0),16),
            ]
        for (str,coord,index) in test {
            let s = SymmetryCode_t(str)
            XCTAssert(s.xyz == coord)
            XCTAssert(s.n == index)
        }
    }

    func testStandardDeviation() {

        _ = {
            let str = "1.00"
            let component = str.cifNumericDeviationComponent
            let su = str.cifNumericDeviationNumber
            XCTAssert( component == nil )
            XCTAssert( su == nil )
        }()

        _ = {
            let str = "1.00(1)"
            let component = str.cifNumericDeviationComponent
            let su = str.cifNumericDeviationNumber
            XCTAssert( component == "1" )
            XCTAssert( fabs( su! - 0.01 ) < .ulpOfOne )
            }()

        _ = {
            let str = "1.00(23)"
            let component = str.cifNumericDeviationComponent
            let su = str.cifNumericDeviationNumber
            XCTAssert( component == "23" )
            XCTAssert( fabs( su! - 0.23 ) < .ulpOfOne )
        }()

        _ = {
            let str = "2.345(67)"
            let component = str.cifNumericDeviationComponent
            let su = str.cifNumericDeviationNumber
            XCTAssert( component == "67" )
            XCTAssert( fabs( su! - 0.067 ) < .ulpOfOne )
        }()


    }

}


