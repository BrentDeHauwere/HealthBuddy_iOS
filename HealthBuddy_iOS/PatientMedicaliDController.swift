//
//  PatientMedicaliDController.swift
//  HealthBuddy_iOS
//
//  Created by Yen Jacobs on 7/03/16.
//  Copyright © 2016 Yen Jacobs. All rights reserved.
//

import UIKit
import BTNavigationDropdownMenu


class PatientMedicaliDController: UIViewController{
    var patient:User!;
    
    @IBOutlet weak var lblCurrentPatient: UILabel!
   
   
    
    override func viewDidLoad() {
        super.viewDidLoad();
        setupDropdownMenu();
 
       
        
        lblCurrentPatient.text = "\(patient.firstName) \(patient.lastName)";
    }
    
    func setupDropdownMenu(){
        let items = ["Medisch ID", "Medicatie", "Gewicht"];
        let menuView = BTNavigationDropdownMenu(navigationController: self.navigationController, title: items.first!, items: items)
        self.navigationItem.titleView = menuView
        menuView.didSelectItemAtIndexHandler = {(indexPath: Int) -> () in
            print("Did select item at index: \(indexPath)")
            // self.selectedCellLabel.text = items[indexPath]
        }

    }
    
    
    

}