//
//  PatientMedicineController.swift
//  HealthBuddy_iOS
//
//  Created by Yen Jacobs on 7/03/16.
//  Copyright © 2016 Yen Jacobs. All rights reserved.
//

import UIKit
import BTNavigationDropdownMenu
class PatientMedicineController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad();
        setupDropdownMenu();
        print("Medicijnen page");
    }
    
    func setupDropdownMenu(){
        let items = ["Medisch ID","Medicatie","Gewicht"];
        let menuView = BTNavigationDropdownMenu(navigationController: self.navigationController, title: items.first!, items: items)
        
        self.navigationItem.titleView = menuView
        menuView.didSelectItemAtIndexHandler = {(indexPath: Int) -> () in
            switch indexPath {
            case 0:
                print("medisch id");
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
