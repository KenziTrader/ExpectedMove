//
//  KTString.swift
//  ExpectedMove
//
//  Created by Rene on 28/06/16.
//  Copyright © 2016 Rene Laterveer. All rights reserved.
//

import Foundation

extension String {
    
    // create formatters only once
    struct Static {
        static let numberFormatter = NSNumberFormatter()
        static let nsDateFormatter = NSDateFormatter()
    }
    
    func asDouble() -> Double? {
        // use right decimal separator
        Static.numberFormatter.decimalSeparator = "."
        Static.numberFormatter.usesGroupingSeparator = true
        Static.numberFormatter.groupingSeparator = ","
        Static.numberFormatter.groupingSize = 3
        Static.numberFormatter.positivePrefix = ""
        Static.numberFormatter.numberStyle = .DecimalStyle
        return Static.numberFormatter.numberFromString(self)?.doubleValue
    }
    
    func percentToDouble() -> Double? {
        // use right decimal separator
        Static.numberFormatter.locale = NSLocale(localeIdentifier: "en_US")
        Static.numberFormatter.positivePrefix = "+"
        Static.numberFormatter.numberStyle = .PercentStyle
        return Static.numberFormatter.numberFromString(self)?.doubleValue
    }
    
    func asInt() -> Int? {
        // use right decimal separator
        return Static.numberFormatter.numberFromString(self)?.integerValue
    }
    
    func asDate() -> NSDate {
        Static.nsDateFormatter.dateFormat = "MM/dd/yy"
        Static.nsDateFormatter.timeZone = NSTimeZone(name: "UTC")
        // Add the locale if required here
        if let dateObj = Static.nsDateFormatter.dateFromString(self) {
            return NSDate(timeInterval:0, sinceDate:dateObj)
        } else {
            // could not parse date string
            return NSDate(timeIntervalSinceReferenceDate:0)
        }
        
    }
}

