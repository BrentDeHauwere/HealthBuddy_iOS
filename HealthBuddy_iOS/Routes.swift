//
//  Routes.swift
//  HealthBuddy_iOS
//
//  Created by Yen Jacobs on 20/03/16.
//  Copyright © 2016 Yen Jacobs. All rights reserved.
//

import Foundation

struct Routes{
    
    //GET DATA
    static let login =  "http://10.3.50.33/api/login";
    //POST: email, password
    
    static let buddyProfile = "http://10.3.50.33/api/buddyprofile";
    //POST: api_token
    
    
    
    
    //UPDATE
    static let updateMedicalInfo = "http://10.3.50.33/api/user/1/medicalinfo/update"
}