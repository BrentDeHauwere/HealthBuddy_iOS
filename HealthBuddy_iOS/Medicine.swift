//
//  Medical.swift
//  HealthBuddy_iOS
//
//  Created by Yen Jacobs on 10/03/16.
//  Copyright © 2016 Yen Jacobs. All rights reserved.
//

import UIKit
import ObjectMapper

class Medicine : Mappable {
    var id: Int?;
    var name: String?;
    var info:String?
    var photo: UIImage?;
    var photo64String:String?;
    var schedules = [MedicalSchedule]();
    
    init(){
        
    }
    
    init(id:Int, name: String, photo:UIImage?){
        self.id = id;
        self.name = name;
        self.photo = photo;
    }
    
    required init?(_ map: Map) {
        mapping(map)
    }
    
    func mapping(map: Map) {
        self.id         <- map["id"]
        self.name       <- map["name"]
        self.info       <- map["info"]
        self.schedules   <- map["schedule"]
        self.photo64String <- map["photo"]
        
        print(self.photo64String);
        if(self.photo64String != nil && self.photo64String != ""){
            let decodedData = NSData(base64EncodedString: self.photo64String!, options: NSDataBase64DecodingOptions(rawValue: 0))
            let decodedimage = UIImage(data: decodedData!)
            print("Image: \(decodedimage)");
            self.photo = decodedimage! as UIImage;
        }
    }
    
    func updateMedicineInfo(medicine:Medicine){
        self.id = medicine.id;
        self.name = medicine.name;
        self.info = medicine.info;
    }

    var description: String {
        return "medicineId: \(self.id)\nname: \(self.name)\ninfo: \(self.info)\nphotoUrl: \nphoto \(self.photo)\nschedule\(self.schedules)";
    }
    
}

