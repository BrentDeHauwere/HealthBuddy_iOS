//
//  Address.swift
//  HealthBuddy_iOS
//
//  Created by Kamiel Klumpers on 24/03/16.
//  Copyright © 2016 Yen Jacobs. All rights reserved.
//

import Foundation
import ObjectMapper

class Address: Mappable {
    var id:Int?
    var street:String?
    var bus:String?
    var zipCode:String?
    var city:String?
    var country:String?
    var streetNumber: String?;
    
    
    required init?(_ map: Map) {
        mapping(map)
    }
    
    func mapping(map: Map) {
        self.id <- map["id"]
        self.street <- map["street"]
        self.bus <- map["bus"]
        self.zipCode <- map["zipCode"]
        self.city <- map["city"]
        self.country <- map["country"]
        self.streetNumber <- map["streetNumber"]
    }
    
    
    var description: String {
        return "id: \(self.id)\nstreet: \(self.street)\nbus: \(self.bus)\nzipCode: \(self.zipCode)\ncity: \(self.city)\ncountry: \(self.country), \(self.streetNumber)";
    }
}
