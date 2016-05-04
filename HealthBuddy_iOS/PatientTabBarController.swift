//
//  BuddyTabBarController.swift
//  HealthBuddy_iOS
//
//  Created by Yen Jacobs on 9/03/16.
//  Copyright © 2016 Yen Jacobs. All rights reserved.
//

import UIKit
import ObjectMapper
import Alamofire

class PatientTabBarController: UITabBarController {
    
    var patient:User?;
    override func viewDidLoad() {
        super.viewDidLoad();
        UINavigationBar.appearance().translucent = false
        let barViewControllers = self.viewControllers
        
        // check if notification fired
        if  let _ = NSUserDefaults.standardUserDefaults().objectForKey("firedMedicineID") as? String,
            let _ = NSUserDefaults.standardUserDefaults().objectForKey("firedScheduleID") as? String {
            
            if let patientJSON = NSUserDefaults.standardUserDefaults().objectForKey("loggedInUser") as? String {
                let patient = Mapper<User>().map(patientJSON)
                self.patient = patient
                self.scheduleRefreshData()
            }
        }
        
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
    
    func scheduleRefreshData(){
        Alamofire.request(.POST, Routes.buddyProfile, parameters: ["api_token": Authentication.token!])
            .responseJSON { response in
                if response.result.isSuccess {
                    if let JSON = response.result.value {
                        let updatedUser = Mapper<User>().map(JSON);
                        self.patient!.updateUserInfo(updatedUser!);
                        self.patient!.medicines = updatedUser?.medicines;
                        print("Data refreshed");
                    }
                }
        }
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
