//
//  DropDownController.swift
//  HealthBuddy_iOS
//
//  Created by Yen Jacobs on 7/03/16.
//  Copyright © 2016 Yen Jacobs. All rights reserved.
//

import UIKit
import BTNavigationDropdownMenu

class DropDownController: NSObject {
    let navigationController: UINavigationController;
    let
    
    //Setup the dropdownmenu for the new screen
    func setupDropdownMenu(viewController: UIViewController){
        let items = ["Medisch ID", "Medicatie", "Gewicht"];
        let menuView = BTNavigationDropdownMenu(navigationController: self.navigationController, title: items.first!, items: items)
        viewController.navigationItem.titleView = menuView
        menuView.didSelectItemAtIndexHandler = {(indexPath: Int) -> () in
            switch indexPath {
            case 0:
                print("medisch id");
                let patientMedicaliDController = (self.storyboard?.instantiateViewControllerWithIdentifier("medicalID_board"))! as! PatientMedicaliDController
                self.navigationController?.pushViewController(patientMedicaliDController, animated: true)
                
            case 1:
                print("Medicine case");
                
                
            case 2:
                print("weight case");
                
                
            default:
                print("Ongeldig menu index");
            }
        }
    }

    
}
