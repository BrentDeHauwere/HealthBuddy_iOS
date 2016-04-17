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
    var time: String?;
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
        self.time       <- map["time"]
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
    }
    
    var description: String {
        return "id: \(self.id), medicineId: \(self.medicineId), time: \(self.time), amount: \(self.amount)";
    }
}
