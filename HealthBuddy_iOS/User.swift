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

class User: Mappable {
    var userId:Int?;
    var buddyId:Int?;
    var addressId:Int?;
    var gender:String?;
    var firstName:String?;
    var lastName:String?;
    var email:String?;
    var dateOfBirth:NSDate?;
    var role:String?;
    var patients:[User]?;
    var medicines:[Medicine]?;

    
    required init?(_ map: Map) {
        mapping(map)
    }
    
    func mapping(map: Map) {
        self.userId      <- map["id"]
        self.buddyId     <- map["buddy_id"]
        self.addressId   <- map["address_id"]
        self.gender      <- map["gender"]
        self.firstName   <- map["firstName"]
        self.lastName    <- map["lastName"]
        self.email       <- map["email"]
        self.dateOfBirth <- (map["dateOfBirth"],DateTransform());
        self.role        <- map["role"] 
        self.patients    <- map["patients"]
        /*
        for var i = 0 ; i < self.patients?.count;i++ {
            self.patients![i].userId      <- map["patients.\(i).id"]
            self.patients![i].buddyId     <- map["patients.\(i).buddy_id"]
            self.patients![i].addressId   <- map["patients.\(i).address_id"]
            self.patients![i].gender      <- map["patients.\(i).gender"]
            self.patients![i].firstName   <- map["patients.\(i).firstName"]
            self.patients![i].lastName    <- map["patients.\(i).lastName"]
            self.patients![i].email       <- map["patients.\(i).email"]
            self.patients![i].dateOfBirth <- map["patients.\(i).dateOfBirth"]
            self.patients![i].role        <- map["patients.\(i).role"]
        }
*/
    }
    
    
    var description: String {
        return "userId: \(self.userId)\nbuddyId: \(self.buddyId)\naddressId: \(self.addressId)\ngender: \(self.gender)\nfirstName: \(self.firstName)\nlastName: \(self.lastName)\nemail: \(self.email)\ndateOfBirth: \(self.dateOfBirth)\nRole: \(self.role)\nPatients: \(self.patients)\n";
    }

    
}