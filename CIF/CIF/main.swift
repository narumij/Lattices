//
//  main.swift
//  CIF
//
//  Created by Jun Narumi on 2016/05/25.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import Foundation

print("Hello, World!")

let arguments = ProcessInfo.processInfo.arguments

print(arguments)

let parser = CIFParser()
do {
    try parser.parse(arguments[1])
    let cif = parser.result
    print(cif.show)
    print("**** query ****")
//print(cif.data[0].query("_atom_site_label"))
    for data in cif.data {
        print( data.items.filter({$0.queryTest("_cell_length_a")}) );
        print( data.items.filter({$0.queryTest("_atom_site_label")}) );
    }
} catch {
    print("parse error")
}
