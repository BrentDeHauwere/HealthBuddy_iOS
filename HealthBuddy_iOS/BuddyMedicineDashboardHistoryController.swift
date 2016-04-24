//
//  BuddyMedicineDashboardHistoryController.swift
//  HealthBuddy_iOS
//
//  Created by Yen Jacobs on 23/04/16.
//  Copyright © 2016 Yen Jacobs. All rights reserved.
//

import UIKit
import RSDayFlow
import MRProgress
import Alamofire
import ObjectMapper

class BuddyMedicineDashboardHistoryController: UIViewController,RSDFDatePickerViewDelegate,RSDFDatePickerViewDataSource {
    var patient:User?;
    var datePicker:RSDFDatePickerView?;
    var selectedDate:NSDate?;
    var progressPerDay:[Progress]?;
    let calendar = NSCalendar.currentCalendar();
    
    override func viewDidLoad() {
        self.datePicker = RSDFDatePickerView(frame: self.view.bounds);
        self.datePicker!.dataSource = self;
        self.datePicker!.delegate = self;
        self.view.addSubview(datePicker!);
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated);
        print("\(self.progressPerDay)")
        if(self.progressPerDay == nil){
            loadProgressPerDay();
        }
    }
    
    func loadProgressPerDay(){
        MRProgressOverlayView.showOverlayAddedTo(self.navigationController?.view, title: "Gegevens ophalen...", mode: .Indeterminate, animated: true) { response in
            MRProgressOverlayView.dismissOverlayForView(self.view, animated: true);
            Manager.sharedInstance.session.getAllTasksWithCompletionHandler { (tasks) -> Void in
                tasks.forEach({ $0.cancel() })
            }
        }
        
        Alamofire.request(.POST, Routes.progressPerDay((self.patient?.userId)!), parameters: ["api_token": Authentication.token!])
            .responseJSON { response in
                MRProgressOverlayView.dismissOverlayForView(self.navigationController?.view, animated: true);
                if(response.result.isSuccess){
                    if let JSON = response.result.value {
                        print(JSON);
                        self.progressPerDay =  Mapper<Progress>().mapArray(JSON);
                        self.datePicker?.reloadData();
                    }
                }else{
                    Alert.alertStatusWithSymbol(false,message: "Gegevens ophalen mislukt", seconds: 1.5, view: self.view);
                    let delay = 1.5 * Double(NSEC_PER_SEC)
                    let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                    dispatch_after(dispatchTime, dispatch_get_main_queue(), {
                        self.tabBarController!.selectedIndex = 0;
                    });
                }
        }
    }
    

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        self.tabBarController!.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Vandaag", style: .Plain, target: self, action: #selector(BuddyMedicineDashboardHistoryController.setDateToday));
    }
    
    func setDateToday(){
        datePicker?.selectDate(NSDate());
        datePicker?.scrollToToday(true);
    }
    
    func datePickerView(view: RSDFDatePickerView!, shouldMarkDate date: NSDate!) -> Bool {
        let unitFlags:NSCalendarUnit = [.Year, .Month, .Day];
        if(self.progressPerDay != nil){
            for (progress) in self.progressPerDay! {
                let progressDateComponents = self.calendar.components(unitFlags, fromDate: progress.day!);
                let progressDate = self.calendar.dateFromComponents(progressDateComponents);
                if(date.isEqual(progressDate)){
                    return true;
                }
            }
        }
        return false;
    }
    
    
    func datePickerView(view: RSDFDatePickerView!, markImageColorForDate date: NSDate!) -> UIColor! {
        let unitFlags:NSCalendarUnit = [.Year, .Month, .Day];
        if(self.progressPerDay != nil){
            for (progress) in self.progressPerDay! {
                let progressDateComponents = self.calendar.components(unitFlags, fromDate: progress.day!);
                let progressDate = self.calendar.dateFromComponents(progressDateComponents);
                if(date.isEqual(progressDate)){
                    if progress.taken == progress.toTake {
                        return UIColor.greenColor();
                    }else{
                        return UIColor.grayColor();
                    }
                }
            }
        }
        return UIColor.grayColor();
    }
    
    
    func datePickerView(view: RSDFDatePickerView!, didSelectDate date: NSDate!) {
        if(selectedDate == date){
            self.performSegueWithIdentifier("showProgress", sender: self);
        }
        selectedDate = date;
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showProgress" {
            let detailPage = segue.destinationViewController as! BuddyMedicineProgressController;
            detailPage.patient = self.patient;
        }

    }
}

