//
//  PatientDashboardController.swift
//  HealthBuddy_iOS
//
//  Created by Yen Jacobs on 17/03/16.
//  Copyright © 2016 Yen Jacobs. All rights reserved.
//

import UIKit

class PatientDashboardController: UIViewController {
    var patient:User?;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        self.title = "\(patient!.firstName!) \(patient!.lastName!)";
        
    }
}
