//
//  Expire.swift
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/05/27.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import Foundation

class Expire : NSObject {
    class func did() -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium;
        dateFormatter.timeStyle = DateFormatter.Style.medium;
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.timeZone = TimeZone.current
        let date = dateFormatter.date(from: "2016/08/27 00:00:00")!
        debugPrint(date)
        return ((date as NSDate).earlierDate(Date()) == date) ? true : false
    }
}

