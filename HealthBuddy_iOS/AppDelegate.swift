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
        
        let viewController = self.window!.rootViewController!.storyboard!.instantiateViewControllerWithIdentifier("PatientMedicineController")
        
        viewController.performSegueWithIdentifier("notificationToMedicine", sender: nil)
        
        self.window?.rootViewController = viewController
    }
    
}

