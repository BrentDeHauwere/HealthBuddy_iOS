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
    var phone:String?;
    var dateOfBirthS:String?;
    var dateOfBirth:NSDate?;
    var role:String?;
    var patients:[User]?;
    var medicines:[Medicine]?;
    var address: Address?;
    var medicalInfo: MedicalInfo?;
    
    required init?(_ map: Map) {
        mapping(map)
    }
    
    func mapping(map: Map) {
        self.userId      <- map["id"]
        self.buddyId     <- (map["buddy_id"], TransformOf<Int, String>(fromJSON: { ($0 == nil) ? nil : Int($0!) }, toJSON: { $0.map { String($0) } }))
        self.addressId   <- (map["address_id"], TransformOf<Int, String>(fromJSON: { ($0 == nil) ? nil : Int($0!) }, toJSON: { $0.map { String($0) } }))
        self.gender      <- map["gender"]
        self.firstName   <- map["firstName"]
        self.lastName    <- map["lastName"]
        self.email       <- map["email"]
        self.phone       <- map["phone"]
        self.dateOfBirthS <- map["dateOfBirth"]
        self.role        <- map["role"] 
        self.patients    <- map["patients"]
        self.medicines   <- map["medicines"]
        self.address     <- map["address"]
        self.medicalInfo <- map["medicalinfo"]
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.dateOfBirth = dateFormatter.dateFromString(self.dateOfBirthS!);
    }
    
    
    var description: String {
        return "userId: \(self.userId)\nbuddyId: \(self.buddyId)\naddressId: \(self.addressId)\ngender: \(self.gender)\nfirstName: \(self.firstName)\nlastName: \(self.lastName)\nemail: \(self.email)\nphone: \(self.phone)\ndateOfBirth: \(self.dateOfBirth)\nRole: \(self.role)\nPatients: \(self.patients)\nMedicines: \(self.medicines), Address: \(self.address?.description), medicalInfo: \(self.medicalInfo?.description)";
    }

    
}