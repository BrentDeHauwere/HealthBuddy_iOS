//
//  User.swift
//  HealthBuddy_iOS
//
//  Created by Yen Jacobs on 7/03/16.
//  Copyright © 2016 Yen Jacobs. All rights reserved.
//

import Foundation

struct User{
    var lastName: String
    var firstName: String
    var buddy_id : Int
    var email: String
    var dateOfBirth: String
    var address: String
    var gender: String
    var role: String
    var address_id: Int
    var id: Int
    var medical_info: String
    
    init(lastName: String,
        firstName: String,
        buddy_id : Int,
        email: String,
        dateOfBirth: String,
        address: String,
        gender: String,
        role: String,
        address_id: Int,
        id: Int,
        medical_info: String){
            self.lastName = lastName
            self.firstName = firstName
            self.buddy_id = buddy_id
            self.email = email
            self.dateOfBirth = dateOfBirth
            self.address = address
            self.gender = gender
            self.role = role
            self.address_id = address_id
            self.id = id
            self.medical_info = medical_info
    }
}