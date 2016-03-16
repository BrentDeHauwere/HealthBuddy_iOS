//
//  DateExtension.swift
//  HealthBuddy_iOS
//
//  Created by Kamiel Klumpers on 10/03/16.
//  Copyright © 2016 Yen Jacobs. All rights reserved.
//

import Foundation

// src:http://stackoverflow.com/questions/24089999/how-do-you-create-a-swift-date-object
// use: NSDate(dateString:"2014-06-06") --> 6 juni 2014


extension NSDate
{
    convenience
    init(dateString:String) {
        let dateStringFormatter = NSDateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd"
        dateStringFormatter.locale = NSLocale(localeIdentifier: "nl_BE")
        let d = dateStringFormatter.dateFromString(dateString)!
        self.init(timeInterval:0, sinceDate:d)
    }
}