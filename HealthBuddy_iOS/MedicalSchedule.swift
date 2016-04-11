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
    var dayOfWeek:Int?
    var time: String?;
    var amount: String?;
    
    init(){
        
    }

    
    init(id:Int, dayOfWeek:Int, time:String, amount:String){
        self.id = id;
        self.dayOfWeek = dayOfWeek;
        self.time = time;
        self.amount = amount;
    }
    
    required init?(_ map: Map) {
        mapping(map)
    }
    
    func mapping(map: Map) {
        self.id         <- map["id"]
        self.medicineId <- (map["medicine_id"], TransformOf<Int, String>(fromJSON: { ($0 == nil) ? nil : Int($0!) }, toJSON: { $0.map { String($0) } }))
        self.dayOfWeek  <- (map["dayOfWeek"], TransformOf<Int, String>(fromJSON: { ($0 == nil) ? nil : Int($0!) }, toJSON: { $0.map { String($0) } }))
        self.time       <- map["time"]
        self.amount     <- map["amount"]
    }
    
    var description: String {
        return "id: \(self.id), medicineId: \(self.medicineId), dayOfWeek: \(self.dayOfWeek), time: \(self.time), amount: \(self.amount)";
    }
}
