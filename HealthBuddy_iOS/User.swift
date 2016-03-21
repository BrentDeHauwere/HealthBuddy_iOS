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
    var firstName:String?;
    var lastName:String?;
    
    init(firstName: String, lastName: String){
        self.firstName = firstName;
        self.lastName = lastName;
    }
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        apiToken    <- map["api_token"]
        userId    <- map["id"]
        firstName   <- map["firstName"]
        lastName    <- map["lastName"]
    }
    
    
    var description: String {
        return "apiToken: \(self.apiToken!)\nuserId: \(self.userId)\nfirstName: \(self.firstName)\nlastName: \(self.lastName)";
    }

    
}