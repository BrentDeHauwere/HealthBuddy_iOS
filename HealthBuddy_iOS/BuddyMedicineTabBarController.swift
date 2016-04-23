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
