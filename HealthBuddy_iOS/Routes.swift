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
    
    static let buddyProfile = "http://10.3.50.33/api/profile";
    //POST: api_token
    
    
    
    //CREATE
    static func createMedicine(patientId:Int)->String {
         return "http://10.3.50.33/api/user/\(patientId)/medicine/create";
    }
    
    //UPDATE
    static func updateUserInfo(patientId: Int) -> String {
        return "http://10.3.50.33/api/user/\(patientId)/update";
    }
    static func updateMedicalInfo(patientId:Int) -> String{
        return "http://10.3.50.33/api/user/\(patientId)/medicalinfo/update";
    }
    
    static func updateAddress(patientId:Int) -> String{
        return "http://10.3.50.33/api/user/\(patientId)/address/update";
    }
    
    //DELETE
    static func deleteMedicine(patientId:Int, medicineId:Int)->String{
        return "http://10.3.50.33/api/user/\(patientId)/medicine/\(medicineId)/delete";
    }
   
}
