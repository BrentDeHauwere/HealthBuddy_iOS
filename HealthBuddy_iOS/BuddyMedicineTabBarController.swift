//
//  BuddyTabBarController.swift
//  HealthBuddy_iOS
//
//  Created by Yen Jacobs on 9/03/16.
//  Copyright © 2016 Yen Jacobs. All rights reserved.
//

import UIKit

class BuddyMedicineTabBarController: UITabBarController {
    var patient:User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UINavigationBar.appearance().translucent = false
        
        let barViewControllers = self.viewControllers;
       
        let medicineList = barViewControllers![0] as! BuddyMedicineController
        medicineList.patient = patient
        
        let historyBoard = barViewControllers![1] as! BuddyMedicineDashboardHistoryController;
        historyBoard.patient = patient;
  
    }
}
