//
//  Regex.swift
//  CIFCommand
//
//  Created by Jun Narumi on 2016/05/23.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import Foundation

class Regexp {
    let internalRegexp: NSRegularExpression

    init(_ pattern: String) {
        self.internalRegexp = try! NSRegularExpression( pattern: pattern, options: .caseInsensitive )
    }

    func isMatch(_ input: String) -> Bool {
        let range = NSRange(location: 0, length: input.characters.count )
        let matches = self.internalRegexp.matches( in: input, options: [], range:range )
        return matches.count > 0
    }

    func matches(_ input: String) -> [String] {
        if self.isMatch(input) {
            let range = NSRange(location: 0, length: input.characters.count )
            let matches = self.internalRegexp.matches( in: input, options: [], range: range )
            return matches.map({
                (input as NSString).substring(with: $0.range)
            })
        }
        return []
    }
}

