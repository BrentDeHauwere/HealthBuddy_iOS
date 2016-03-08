//
//  PatientMedicaliDController.swift
//  HealthBuddy_iOS
//
//  Created by Yen Jacobs on 7/03/16.
//  Copyright © 2016 Yen Jacobs. All rights reserved.
//

import UIKit
import BTNavigationDropdownMenu



class BudyMedicaliDController: UIViewController{
    var patient:User!;
    @IBOutlet weak var lblCurrentPatient: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        lblCurrentPatient.text = "\(patient.firstName) \(patient.lastName)";
    }
    

   
    
    

}