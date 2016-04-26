//
//  Progress.swift
//  HealthBuddy_iOS
//
//  Created by Yen Jacobs on 24/04/16.
//  Copyright © 2016 Yen Jacobs. All rights reserved.
//

import ObjectMapper
import Foundation

class Progress: Mappable {
    var day_s:String?
    var day:NSDate?
    var taken:Int?
    var toTake:Int?
    
    
    required init?(_ map: Map) {
        mapping(map)
    }
    
    func mapping(map: Map) {
        self.day_s      <- map["day"]
        self.taken      <- map["taken"]
        self.toTake     <- map["toTake"]

        let dateFormatter = NSDateFormatter()
        dateFormatter.timeZone = NSTimeZone(abbreviation: "GMT+0:00");
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.day = dateFormatter.dateFromString(self.day_s!);
    }
    
}
