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
    
    static func showMedicine(patientId:Int, medicineId:Int)->String {
        return "http://10.3.50.33/api/user/\(patientId)/medicine/\(medicineId)/show";
    }
    
    //CREATE
    static func createMedicine(patientId:Int)->String {
         return "http://10.3.50.33/api/user/\(patientId)/medicine/create";
    }
    
    static func createSchedule(patientId:Int, medicineId:Int)->String {
        return "http://10.3.50.33/api/user/\(patientId)/medicine/\(medicineId)/schedule/create";
    }
    
    /* api/user/myuserid/schedule/scheduleid/intake/create ALLEEN APITOKEN*/
    static func createIntake(patientId:Int, scheduleId:Int)->String {
        return "http://10.3.50.33/api/user/\(patientId)/schedule/\(scheduleId)/intake/create";
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
    
    static func updateMedicine(patientId: Int, medicineId:Int)->String {
        return "http://10.3.50.33/api/user/\(patientId)/medicine/\(medicineId)/update";
    }
    
    static func updateScheudle(patientId:Int, medicineId:Int, scheduleId:Int)->String {
        return "http://10.3.50.33/api/user/\(patientId)/medicine/\(medicineId)/schedule/\(scheduleId)/update";
    }
    
    //DELETE
    static func deleteMedicine(patientId:Int, medicineId:Int)->String{
        return "http://10.3.50.33/api/user/\(patientId)/medicine/\(medicineId)/delete";
    }
    static func deleteSchedule(patientId:Int, medicineId:Int, scheduleId:Int)->String{
        return "http://10.3.50.33/api/user/\(patientId)/medicine/\(medicineId)/schedule/\(scheduleId)/delete";
    }
   
}
