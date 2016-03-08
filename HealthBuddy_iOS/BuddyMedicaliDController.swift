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
    
    @IBOutlet weak var lblMedicalID: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad();
       // setupBackButtonToMainMenu();
        lblMedicalID.text = "Medisch ID";
        self.navigationItem.title = "\(patient.firstName) \(patient.lastName)";
    }
    
    func setupBackButtonToMainMenu(){
        self.navigationController?.navigationBar.backIndicatorImage = UIImage(named: "Menu");
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "Menu");
    }
}