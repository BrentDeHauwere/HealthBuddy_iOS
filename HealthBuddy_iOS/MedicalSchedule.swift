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
        
        if(self.start_date_s != nil && self.end_date_s != nil){
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            self.start_date = dateFormatter.dateFromString(self.start_date_s!);
            self.end_date = dateFormatter.dateFromString(self.end_date_s!);
        }
        
        if(self.time_s != nil){
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "HH:mm:ss"
            self.time = dateFormatter.dateFromString(self.time_s!);
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
    
    var description: String {
        return "id: \(self.id), medicineId: \(self.medicineId), time: \(self.time), amount: \(self.amount)";
    }
}
