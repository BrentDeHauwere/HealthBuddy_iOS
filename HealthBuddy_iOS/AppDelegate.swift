//
//  AppDelegate.swift
//  HealthBuddy_iOS
//
//  Created by Yen Jacobs on 6/03/16.
//  Copyright © 2016 Yen Jacobs. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil))
        IQKeyboardManager.sharedManager().enable = true
        
        return true
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        NSNotificationCenter.defaultCenter().postNotificationName("TodoListShouldRefresh", object: self)
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        TodoList.sharedInstance.clear()
    }
    
    // notification has fired
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        let medID = notification.userInfo!["medicineID"] as! String
        let schedID = notification.userInfo!["scheduleID"] as! String
        
        NSUserDefaults.standardUserDefaults().setObject(medID, forKey: "firedMedicineID")
        NSUserDefaults.standardUserDefaults().setObject(schedID, forKey: "firedScheduleID")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tc = storyboard.instantiateViewControllerWithIdentifier("patientTabBarController") as! UITabBarController
        
        let nc1 = storyboard.instantiateViewControllerWithIdentifier("dashboardNavigationController") as! UINavigationController
        
        let nc2 = storyboard.instantiateViewControllerWithIdentifier("medicationNavigation") as! UINavigationController
        
        let vc1 = storyboard.instantiateViewControllerWithIdentifier("PatientTableShowMedicineController")
        
        let vc2 = storyboard.instantiateViewControllerWithIdentifier("patientDashboardController")
        
        nc1.addChildViewController(vc1)
        nc2.addChildViewController(vc2)
        
        tc.viewControllers = [nc1,nc2]
        
        self.window?.rootViewController = tc
        
        print("GODVERDOMME SCHIJTCODE")
        
        if self.window!.rootViewController as? UITabBarController != nil {
            let tabbarController = self.window!.rootViewController as! UITabBarController
            tabbarController.selectedIndex = 0
        
            let navController1 = tabbarController.selectedViewController as! UINavigationController
            navController1.pushViewController(vc2, animated: false)
            
            tabbarController.selectedIndex = 1
            
            let navController2 = tabbarController.selectedViewController as! UINavigationController
            navController2.pushViewController(vc1, animated: true)
        }
        
        
        print("achievement get")
    }
    
}

