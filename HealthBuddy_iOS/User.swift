//
//  User.swift
//  HealthBuddy_iOS
//
//  Created by Yen Jacobs on 7/03/16.
//  Copyright © 2016 Yen Jacobs. All rights reserved.
//

import Foundation


class User{
    var id:Int = -1;
    var firstName:String = "";
    var lastName:String = "";
    
    init(firstName: String, lastName: String){
        self.firstName = firstName;
        self.lastName = lastName;
    }
    
    
}