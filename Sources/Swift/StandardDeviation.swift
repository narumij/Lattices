//
//  String+StandardDeviation.swift
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/11/07.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import Foundation

fileprivate let simpleNumberPattern = "([0-9+-.eE]+)(?:\\([0-9]+\\))"
fileprivate let simpleDeviationPattern = "\\(([0-9]+)\\)"
fileprivate let simpleAccuracyPattern = "\\.([0-9]+)"

protocol StandardDeviation {
    var cifNumericNumberComponent: String? { get }
    var cifNumericDeviationComponent: String? { get }
    var cifNumericDeviationNumber: Double? { get }
}

extension String: StandardDeviation {

    fileprivate var myRange: NSRange {
        return NSMakeRange(0,self.length)
    }

    var cifNumericNumberComponent: String? {
        let regex = try! NSRegularExpression( pattern: simpleNumberPattern, options: [] )
        guard let result = regex.firstMatch(in: self, options: [], range: myRange) else {
            return nil
        }
        let numberRange = result.rangeAt(1)
        if numberRange.location == NSNotFound {
            return nil
        }
        return (self as NSString).substring(with: numberRange)
    }

    var cifNumericDeviationComponent: String? {
        let regex = try! NSRegularExpression(pattern: simpleDeviationPattern, options: [] )
        guard let result = regex.firstMatch(in: self, options: [], range: myRange) else {
            return nil
        }
        let numberRange = result.rangeAt(1)
        if numberRange.location == NSNotFound {
            return nil
        }
        return (self as NSString).substring(with: numberRange)
    }

    fileprivate func accuracyLog10(_ str: String ) -> Int {
        let regex = try! NSRegularExpression(pattern: simpleAccuracyPattern, options: [] )
        guard let result = regex.firstMatch(in: self, options: [], range: myRange) else {
            return 0
        }
        let numberRange = result.rangeAt(1)
        if numberRange.location == NSNotFound {
            return 0
        }
        return (self as NSString).substring(with: numberRange).length
    }

    var cifNumericDeviationNumber: Double? {
        guard let str = cifNumericDeviationComponent else {
            return nil
        }
        guard let numComponent = cifNumericNumberComponent else {
            return nil
        }
        let standardDeviationInteger = (str as NSString).doubleValue
        let accuracy = accuracyLog10(numComponent)
        return standardDeviationInteger / pow( 10.0, Double(accuracy) )
    }

}









