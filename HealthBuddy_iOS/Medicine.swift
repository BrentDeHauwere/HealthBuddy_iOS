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
    var photoUrl:String?;
    var photo: UIImage? = UIImage(named: "selectImage");
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
        self.photoUrl   <- map["photoUrl"]
        self.schedules   <- map["schedule"]
    }
    var description: String {
        return "medicineId: \(self.id)\nname: \(self.name)\ninfo: \(self.info)\nphotoUrl: \(self.photoUrl)\nphoto \(self.photo)\nschedule\(self.schedules)";
    }
    
}

