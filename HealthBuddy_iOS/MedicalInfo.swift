//
//  MedicalInfo.swift
//  HealthBuddy_iOS
//
//  Created by Kamiel Klumpers on 24/03/16.
//  Copyright © 2016 Yen Jacobs. All rights reserved.
//

import Foundation


import Foundation
import ObjectMapper

class MedicalInfo: Mappable {
    var id:Int?
    var user_id:Int?
    var length:Int?
    var weight:Double?
    var bloodType:String?
    var medicalCondition:String?
    var allergies:String?
    
    required init?(_ map: Map) {
        mapping(map)
    }
    
    func mapping(map: Map) {
        self.id <- map["id"]
        self.user_id <- map["user_id"]
        self.length <- map["length"]
        self.weight <- map["weight"]
        self.bloodType <- map["bloodType"]
        self.medicalCondition <- map["medicalCondition"]
        self.allergies <- map["allergies"]
    }
    
    var description: String {
        return "id: \(id) \nuser_id: \(user_id) \nlength: \(length) \nweight: \(weight) \nbloodType: \(bloodType) \nmedicalCondition: \(medicalCondition) \nallergies: \(allergies) \n";
    }
}
