//
//  MedicalSchedule.swift
//  HealthBuddy_iOS
//
//  Created by Yen Jacobs on 12/03/16.
//  Copyright © 2016 Yen Jacobs. All rights reserved.
//

import UIKit

class MedicalSchedule {
    var id:Int = -1;
    var dayOfWeek:Int = -1;
    var time: String = "";
    var amount: Int = -1;
    
    init(){
        
    }

    
    init(id:Int, dayOfWeek:Int, time:String, amount:Int){
        self.id = id;
        self.dayOfWeek = dayOfWeek;
        self.time = time;
        self.amount = amount;
    }
    
}
