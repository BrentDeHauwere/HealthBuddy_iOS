//
//  MedicalSchedule.swift
//  HealthBuddy_iOS
//
//  Created by Yen Jacobs on 12/03/16.
//  Copyright © 2016 Yen Jacobs. All rights reserved.
//

import UIKit
import ObjectMapper

class MedicalSchedule : Mappable {
    var id:Int?
    var medicineId:Int?
    var time_s: String?;
    var time:NSDate?;
    var amount: String?;
    var interval: Int?;
    var start_date_s:String?;
    var end_date_s:String?;
    var start_date:NSDate?;
    var end_date:NSDate?;
    var updated_at_s:String?;
    var updated_at:NSDate?;
  
    
    init(){
        
    }
    
    required init?(_ map: Map) {
        mapping(map)
    }
    
    func mapping(map: Map) {
        self.id         <- map["id"]
        self.medicineId <- (map["medicine_id"], TransformOf<Int, String>(fromJSON: { ($0 == nil) ? nil : Int($0!) }, toJSON: { $0.map { String($0) } }))
        self.time_s       <- map["time"]
        self.amount     <- map["amount"]
        self.interval <- (map["interval"], TransformOf<Int, String>(fromJSON: { ($0 == nil) ? nil : Int($0!) }, toJSON: { $0.map { String($0) } }))
        self.start_date_s <- map["start_date"]
        self.end_date_s <- map["end_date"]
        self.updated_at_s <- map["updated_at"]
        
        if(self.start_date_s != nil && self.end_date_s != nil){
            let dateFormatter = NSDateFormatter()
            dateFormatter.timeZone = NSTimeZone(abbreviation: "GMT+0:00");
            dateFormatter.dateFormat = "yyyy-MM-dd"
            self.start_date = dateFormatter.dateFromString(self.start_date_s!);
            self.end_date = dateFormatter.dateFromString(self.end_date_s!);
        }
        
        if(self.time_s != nil){
            let dateFormatter = NSDateFormatter()
            dateFormatter.timeZone = NSTimeZone(abbreviation: "GMT+0:00");
            dateFormatter.dateFormat = "HH:mm:ss"
            self.time = dateFormatter.dateFromString(self.time_s!);
        }
        
        if(self.updated_at_s != nil){
            let dateFormatter = NSDateFormatter()
            dateFormatter.timeZone = NSTimeZone(abbreviation: "GMT+0:00");
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss";
            self.updated_at = dateFormatter.dateFromString(self.updated_at_s!);
        }
        
        if(self.time == nil){
            self.time = NSDate();
        }
      
        
        if(self.start_date == nil){
            self.start_date = NSDate();
        }
        if(self.end_date == nil){
            self.end_date = NSDate();
        }
    }
    
    func updateSchedule(schedule:MedicalSchedule){
        self.id = schedule.id;
        self.medicineId = schedule.medicineId;
        self.time_s = schedule.time_s;
        self.amount = schedule.amount;
        self.start_date_s = schedule.start_date_s;
        self.end_date_s = schedule.end_date_s;
        self.time = schedule.time;
        self.start_date = schedule.start_date;
        self.end_date = schedule.end_date;
        self.interval = schedule.interval;
    }
    
    var description: String {
        return "id: \(self.id), medicineId: \(self.medicineId), time: \(self.time), amount: \(self.amount)";
    }
}
