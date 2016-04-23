//
//  BuddyMedicineDashboardHistoryController.swift
//  HealthBuddy_iOS
//
//  Created by Yen Jacobs on 23/04/16.
//  Copyright © 2016 Yen Jacobs. All rights reserved.
//

import UIKit
import RSDayFlow

class BuddyMedicineDashboardHistoryController: UIViewController,RSDFDatePickerViewDelegate,RSDFDatePickerViewDataSource {
    var patient:User?;
    var datePicker:RSDFDatePickerView?;
    var selectedDate:NSDate?;
    
    override func viewDidLoad() {
        self.datePicker = RSDFDatePickerView(frame: self.view.bounds);
        self.datePicker!.dataSource = self;
        self.datePicker!.delegate = self;
        self.view.addSubview(datePicker!);
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        self.tabBarController!.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Vandaag", style: .Plain, target: self, action: #selector(BuddyMedicineDashboardHistoryController.setDateToday));
    }
    
    func setDateToday(){
        datePicker?.selectDate(NSDate());
    }
    
    func datePickerView(view: RSDFDatePickerView!, shouldMarkDate date: NSDate!) -> Bool {
        return true;
    }
    
    func datePickerView(view: RSDFDatePickerView!, markImageColorForDate date: NSDate!) -> UIColor! {
        if (arc4random() % 2 == 0) {
            return UIColor.grayColor();
        } else {
            return UIColor.greenColor();
        }
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
