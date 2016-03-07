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
    
    @IBOutlet weak var navigationTitle: UINavigationItem!
   
    
    override func viewDidLoad() {
        super.viewDidLoad();
        navigationItem.title = "\(patient.firstName) \(patient.lastName)";
    }
    
}