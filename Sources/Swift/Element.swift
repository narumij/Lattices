//
//  Element.swift
//  AtomColors
//
//  Created by Jun Narumi on 2016/06/17.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import UIKit

//func symbolToColor( symbol: String ) -> UIColor {
//    return UIColor.whiteColor()
//}
//
//func symbolToRadius( symbol: String, type: RadiiType ) -> CGFloat {
//    return 1.0
//}

class Element: NSObject {

    var number : Int = 0 // 自然数で数える
    var type : String { return types[number - 1] }
//    var fullType : String { return fullTypes[number - 1] }
//    var localizedFullType : String {
//        return NSLocalizedString( fullType, comment: "" )
//    }

    dynamic var color : Color = Color.white
    dynamic var info : [String:AnyObject] = [:]

    override init() {
    }

    init( _ number: Int) {
        self.number = number
    }

    init?(coder aDecoder: NSCoder) {
        number = aDecoder.decodeInteger( forKey: "number" )
        color  = aDecoder.decodeObject( forKey: "color" ) as! Color
        info   = aDecoder.decodeObject( forKey: "info" ) as! [String:AnyObject]
    }

    func encodeWithCoder( _ aCoder: NSCoder) {
        aCoder.encode( number, forKey: "number" )
        aCoder.encode( color, forKey: "color" )
        aCoder.encode( info, forKey: "info" )
    }

    var element : Element {
        get { return self }
        set(e) {
            self.number = e.number
            self.color = e.color
        }
    }

    override var debugDescription: String {
        return "Element( \(type), number:\(number), period:\(period) row:\(row) col:\(col) )"
    }

    var period : Int {
        switch number {
        case (1...2):
            return 1
        case (3...10):
            return 2
        case (11...18):
            return 3
        case (19...36):
            return 4
        case (37...54):
            return 5
        case (55...86):
            return 6
        case (87...118):
            return 7
        default:
            break;
        }
        return 0
    }

    var isLanthanide : Bool {
        return (57...70).contains(number)
    }

    var isActinide : Bool {
        return (89...102).contains(number)
    }

    var row : Int {
        if isLanthanide {
            return 8
        }
        if isActinide {
            return 9
        }
        return period
    }

    var col : Int {
        switch number {
        case 1:
            return 1
        case 2:
            return 18
        case 3...4:
            return number - 2
        case 5...10:
            return number + 8
        case 11...12:
            return number - 10
        case 13...18:
            return number
        case 19...36:
            return number - 18
        case 37...54:
            return number - 36
        case 55...70:
            return number - 54
        case 71...86:
            return number - 68
        case 87...102:
            return number - 86
        case 103...118:
            return number - 100
        default:
            break
        }
        return 0
    }

    func frame( _ size:CGSize, margin:CGSize, gap:CGSize ) -> CGRect {
        let i = CGFloat(col - 1)
        let j = CGFloat(row - 1)
        let stride = CGSize( width: size.width + margin.width, height: size.height + margin.height )
        var x = stride.width * i
        var y = stride.height * j
        x = i < 2 ? x : x + gap.width
        y = j < 7 ? y : y + gap.height
        return CGRect( origin: CGPoint( x: x, y: y ), size: size )
    }

}

extension String {
    #if os(OSX)
    var length : Int {
        return self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)
    }
    #endif
}

class PeriodicTable : NSObject {
    let elements : [Element]
    override init() {
        elements = types.enumerated().map {
            ( index: Int, element: String ) -> Element in
            let num = index + 1
            return Element(num)
        }
    }

    func element( _ name: String ) -> Element? {
        return elements.filter({ $0.type == name }).first
    }

    #if os(OSX)
    func readFromURL( url: NSURL,
                       ofType typeName: String) throws {
        let pathExtension = url.pathExtension

        if pathExtension?.lowercaseString == "txt" {
            let string = try NSString( contentsOfURL: url, encoding: NSUTF8StringEncoding )
            var blocks = string.componentsSeparatedByString("\nELMT")
            var lines = blocks[1].componentsSeparatedByString("\n")
            var radii : [Element] = []
            for line in lines {
                if line.length == 0 {
                    continue
                }
                var words : [NSString] = line
                    .componentsSeparatedByCharactersInSet(NSCharacterSet(charactersInString: " \t"))
                    .filter({ (string) -> Bool in
                        string.length > 0
                    })
                func createColor( x:NSString, _ y:NSString, _ z: NSString ) -> Color {
                    return Color(red: CGFloat(words[2].doubleValue), green: CGFloat(words[3].doubleValue), blue: CGFloat(words[4].doubleValue), alpha: 1.0)
                }
                let color = createColor(words[2],words[3],words[4])
                let e = element(words[0] as String)
                e?.color = color
                e?.info["radius"] = words[1].doubleValue
            }
        }

        if pathExtension == colorAndRadiiExtension {
            if let path = url.path {
                let save = NSKeyedUnarchiver.unarchiveObjectWithFile(path) as! [Element]
                for (i,s) in save.enumerate() {
                    elements[i].element = s
                }
            }
        }
    }

    func writeToURL( url: NSURL,
                     ofType typeName: String) throws {
        if let path = url.path {
            NSKeyedArchiver.archiveRootObject( elements, toFile: path )
        }
    }
    #endif
}




let types = [
    "H",
        "He",

    "Li","Be",
        "B","C","N","O","F","Ne",

    "Na","Mg",
        "Ai","Si","P","S","Cl","Ar",

    "K","Ca",
        "Sc","Ti","V","Cr","Mn","Fe","Co","Ni","Cu","Zn", "Ga","Ge","As","Se","Br","Kr",

    "Rb","Sr",
        "Y","Zr","Nb","Mo","Tc","Ru","Rh","Pd","Ag","Cd", "In","Sn","Sb","Te","I","Xe",

    "Cs","Ba",
    "La","Ce","Pr","Nd","Pm","Sm","Eu","Gd","Tb","Dy","Ho","Er","Tm","Yb",
        "Lu","Hf","Ta","W","Re","Os","Ir","Pt","Au","Hg","Tl","Pb","Bi","Po","At","Rn",

    "Fr","Ra",
    "Ac","Th","Pa","U","Np","Pu","Am","Cm","Bk","Cf","Es","Fm","Md","No",
        "Lr","Rf","Db","Sg","Bh","Hs","Mt","Ds","Rg","Cn","Nh","Fl","Mc","Lv","Ts","Og",
]

//let fullTypes = [
//    "Hydrogen",
//        "Helium",
//
//    "Lithium","Berylium",
//        "Boron","Carbon","Nitrogen","Oxygen","Fluorine","Neon",
//
//    "Sodium","Magnesium",
//        "Aluminium","Silicon","Phosphorus","Sulfur","Chlorine","Argon",
//
//    "Potasium","Calcium",
//        "Scandium","Titanium","Vandadium","Chromium","Manganese","Iron","Cobalt","Nickel","Copper",
//        "Zinc","Gallium","Germanium","Arsenic","Selenium","Bromine","Krypton",
//
//    "Rubidium","Strontium",
//        "Yttrium","Zirconium","Niobium","Molybdenum","Technetium","Ruthenium","Rhodium","Palladium",
//        "Silver","Cadmium","Indium","Tin","Antimony","Tellurium","Iodine","Xenon",
//
//    "Caesium","Barium",
//    "Lanthanum","Cerium","Praseodymium","Neodymium","Promethium","Samarium","Europium","Gadolinium",
//    "Terbium","Dysprosium","Holmium","Erbium","Thulium","Ytterbium",
//        "Lutetium","Hafnium","Tantalum","Tungsten","Rhenium","Osmium","Iridium","Platinum",
//        "Gold","Mercury","Thallium","Lead","Bismuth","Polonium","Astatine","Radon",
//
//    "Francium","Radium",
//    "Actinium","Thorium","Protactium","Uranium","Neptunium","Plutonium","Americium","Curium",
//    "Berkelium","Californium","Einsteinium","Fermium","Mendelevium","Nobelium",
//        "Lawrencium","Rutherfordium","Dubnium","Seaborgium","Bohrium","Hassium","Meitnerium","Darmstadium",
//        "Roentgenium","Copernicium","Nihonium","Flerovium","Moscovium","Livermorium","Tennessine","Oganesson"
//]






