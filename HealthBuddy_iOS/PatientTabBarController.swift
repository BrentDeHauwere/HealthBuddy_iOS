//
//  BuddyTabBarController.swift
//  HealthBuddy_iOS
//
//  Created by Yen Jacobs on 9/03/16.
//  Copyright © 2016 Yen Jacobs. All rights reserved.
//

import UIKit

class PatientTabBarController: UITabBarController {
    
    var patient:User?;
    override func viewDidLoad() {
        super.viewDidLoad();
        UINavigationBar.appearance().translucent = false
        let barViewControllers = self.viewControllers
        
        let destinationNavigationController = barViewControllers![0] as! UINavigationController
        let patientDashboard = destinationNavigationController.viewControllers[0] as! PatientDashboardController
        patientDashboard.patient = patient
        
        let destinationNavigationController2 = barViewControllers![1] as! UINavigationController
        let patientMedicine = destinationNavigationController2.viewControllers[0] as! PatientMedicineController
        patientMedicine.patient = patient
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
