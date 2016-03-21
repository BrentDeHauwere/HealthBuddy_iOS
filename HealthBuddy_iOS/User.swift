//
//  User.swift
//  HealthBuddy_iOS
//
//  Created by Yen Jacobs on 7/03/16.
//  Copyright © 2016 Yen Jacobs. All rights reserved.
//

import Foundation
import ObjectMapper

struct Roles{
    static let Zorgmantel = "Zorgmantel";
    static let zorgBehoevende = "Zorgbehoevende";
}

class User: Mappable{
    var apiToken:String?;
    var userId:Int?;
    var buddyId:Int?;
    var addressId:String?;
    var gender:String?;
    var firstName:String?;
    var lastName:String?;
    var email:String?;
    var dateOfBirth:String?;
    var role:String?;
    var patients:[User]?;
    
    init(firstName: String, lastName: String){
        self.firstName = firstName;
        self.lastName = lastName;
    }
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.apiToken    <- map["api_token"]
        self.userId      <- map["profile.id"]
        self.buddyId     <- map["profile.buddy_id"]
        self.addressId   <- map["profile.address_id"]
        self.gender      <- map["profile.gender"]
        self.firstName   <- map["profile.firstName"]
        self.lastName    <- map["profile.lastName"]
        self.email       <- map["profile.email"]
        self.dateOfBirth <- map["profile.dateOfBirth"]
        self.role        <- map["profile.role"]
        self.patients    <- map["profile.patients"]
        for var i = 0 ; i < self.patients?.count;i++ {
            self.patients![i].userId      <- map["profile.patients.\(i).id"]
            self.patients![i].buddyId     <- map["profile.patients.\(i).buddy_id"]
            self.patients![i].addressId   <- map["profile.patients.\(i).address_id"]
            self.patients![i].gender      <- map["profile.patients.\(i).gender"]
            self.patients![i].firstName   <- map["profile.patients.\(i).firstName"]
            self.patients![i].lastName    <- map["profile.patients.\(i).lastName"]
            self.patients![i].email       <- map["profile.patients.\(i).email"]
            self.patients![i].dateOfBirth <- map["profile.patients.\(i).dateOfBirth"]
            self.patients![i].role        <- map["profile.patients.\(i).role"]
        }
    }
    
    
    var description: String {
        return "apiToken: \(self.apiToken)\nuserId: \(self.userId)\nbuddyId: \(self.buddyId)\naddressId: \(self.addressId)\ngender: \(self.gender)\nfirstName: \(self.firstName)\nlastName: \(self.lastName)\nemail: \(self.email)\ndateOfBirth: \(self.dateOfBirth)\nRole: \(self.role)\nPatients: \(self.patients)\n";
    }

    
}