//
//  Medical.swift
//  HealthBuddy_iOS
//
//  Created by Yen Jacobs on 10/03/16.
//  Copyright © 2016 Yen Jacobs. All rights reserved.
//

import UIKit

class Medicine{
    var id: Int = -1;
    var name: String = "";
    var photo: UIImage? = UIImage(named: "selectImage");
    var schedule = [MedicalSchedule]();
    
    init(){
        
    }
    init(id:Int, name: String, photo:UIImage?){
        self.id = id;
        self.name = name;
        self.photo = photo;
    }
}

