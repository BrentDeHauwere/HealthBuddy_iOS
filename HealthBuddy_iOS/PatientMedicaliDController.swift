//
//  PatientMedicaliDController.swift
//  HealthBuddy_iOS
//
//  Created by Yen Jacobs on 7/03/16.
//  Copyright © 2016 Yen Jacobs. All rights reserved.
//

import UIKit

class PatientMedicaliDController: UIViewController{
    var patient:User!;
    
    @IBOutlet weak var lblTest: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        lblTest.text = "\(patient.firstName) \(patient.lastName)";
    }
    
}