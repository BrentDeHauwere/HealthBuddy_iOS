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
        setupCustomBackBtn();
        lblCurrentPatient.text = "\(patient.firstName) \(patient.lastName)";
    }
    

    
    func setupCustomBackBtn(){
        self.navigationController?.navigationBar.backIndicatorImage = UIImage(named: "ContactenLogo");
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "ContactenLogo");
    }
    
    

}