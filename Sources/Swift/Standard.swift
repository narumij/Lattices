//
//  Standard.swift
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/09/04.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import Foundation

func nub<T:Equatable>( _ array: [T] ) -> [T] {
    return array.reduce([]) { $0.contains($1) ? $0 : $0 + [$1] }
}

func nub<T>( _ array: [T], isEquivalent: (T,T) -> Bool ) -> [T] {
    return array.reduce([]) {
        ( xs: [T], x: T ) -> [T] in
        xs.filter( { isEquivalent( $0, x ) } ).count != 0 ? xs : xs + [x]
    }
}

