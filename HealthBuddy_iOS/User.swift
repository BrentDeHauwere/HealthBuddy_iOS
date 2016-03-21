//
//  User.swift
//  HealthBuddy_iOS
//
//  Created by Yen Jacobs on 7/03/16.
//  Copyright © 2016 Yen Jacobs. All rights reserved.
//

import Foundation
import ObjectMapper

class User: Mappable{
    var apiToken:String?;
    var userId:Int?;
    var buddyId:Int?;
    var addressId:Int?;
    var gender:String?;
    var firstName:String?;
    var lastName:String?;
    var email:String?;
    var dateOfBirth:String?;
    var role:String?
    
    init(firstName: String, lastName: String){
        self.firstName = firstName;
        self.lastName = lastName;
    }
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        apiToken    <- map["api_token"]
        userId      <- map["profile.id"]
        buddyId     <- map["profile.buddy_id"]
        addressId   <- map["profile.address_id"]
        gender      <- map["profile.gender"]
        firstName   <- map["profile.firstName"]
        lastName    <- map["profile.lastName"]
        email       <- map["profile.email"]
        dateOfBirth <- map["profile.dateOfBirth"]
        role        <- map["profile.role"]
    }
    
    
    var description: String {
        return "apiToken: \(self.apiToken)\nuserId: \(self.userId)\nbuddyId: \(self.buddyId)\naddressId: \(self.addressId)\ngender: \(self.gender)\nfirstName: \(self.firstName)\nlastName: \(self.lastName)\nemail: \(self.email)\ndateOfBirth: \(self.dateOfBirth)\nRole: \(self.role)\n";
    }

    
}