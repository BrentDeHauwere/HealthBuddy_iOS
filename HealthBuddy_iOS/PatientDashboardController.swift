//
//  PatientDashboardController.swift
//  HealthBuddy_iOS
//
//  Created by Yen Jacobs on 17/03/16.
//  Copyright © 2016 Yen Jacobs. All rights reserved.
//

import UIKit
import CircleProgressView
import ObjectMapper;

class PatientDashboardController: UIViewController {
    @IBOutlet weak var circleProgressView: CircleProgressView!
    
    var patient:User?;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        // check if notification fired
        if  let _ = NSUserDefaults.standardUserDefaults().objectForKey("firedMedicineID") as? String,
            let _ = NSUserDefaults.standardUserDefaults().objectForKey("firedScheduleID") as? String {
            
            if let patientJSON = NSUserDefaults.standardUserDefaults().objectForKey("loggedInUser") as? String {
                let patient = Mapper<User>().map(patientJSON)
                print("\(patient!.firstName!) \(patient!.lastName!)")
                self.patient = patient
            }
        }
        
        self.title = "\(patient!.firstName!) \(patient!.lastName!)";
    }
    
    override func viewDidAppear(animated: Bool) {
        print("PROGRESS CALCULATE");
        //calculateProgress()
        circleProgressView.setProgress(calculateProgress(), animated: true);
    }
    
    // Medicine has to be taken when
    // - Today is between Schedule.start_date and Schedule.end_date
    // - (Today - Schedule.start_date) % Schedule.interval == 0
    
    // Medicine is taken when
    // - Schedule.updated_at == Today ! ================================ TO DO: UPDATED_AT ================================== !
    func calculateProgress() -> Double {
        if(self.patient?.gender == "M"){
            self.circleProgressView.centerImage = UIImage(named: "takePillMan");
        }else{
            self.circleProgressView.centerImage = UIImage(named: "takePillWoman");
        }
        
        var medicinesToTake:Int = 0;
        var medicinesTaken:Int = 0;
        if(self.patient?.medicines != nil){
            for medicine in (patient?.medicines)! {
                for schedule in medicine.schedules {
                    if NSDate().isBetweeen(date: schedule.start_date!, andDate: schedule.end_date!)
                        &&  (NSDate().daysSince1970() - schedule.start_date!.daysSince1970()) % schedule.interval! == 0 {
                        medicinesToTake += 1;
                        
                        if schedule.updated_at != nil && schedule.updated_at!.sameDay(NSDate()) {
                            medicinesTaken += 1;
                        }
                    }
                    
                }
            }
            if(medicinesToTake == medicinesTaken){
                self.circleProgressView.centerImage = UIImage(named: "trofee");
            }
            
        }
        
        print("\(medicinesTaken)/\(medicinesToTake)")
        if(self.patient?.medicines != nil){
            return Double(medicinesTaken)/Double(medicinesToTake);
        }
        else{
            return 0;
        }
    }
}

extension NSDate {
    func isBetweeen(date date1: NSDate, andDate date2: NSDate) -> Bool {
        return date1.compare(self).rawValue * self.compare(date2).rawValue >= 0
    }
    
    func daysSince1970() -> Int {
        if(self.timeIntervalSince1970 / (60*60*24) == floor(self.timeIntervalSince1970 / (60*60*24))){
            return (Int)(self.timeIntervalSince1970 / (60*60*24));
        }else{
            return ((Int)(self.timeIntervalSince1970 / (60*60*24)) + 1);
        }
        
    }
    
    func sameDay(dateTwo:NSDate) -> Bool {
        let calender = NSCalendar.currentCalendar()
        let flags: NSCalendarUnit = [.Day, .Month, .Year]
        let compOne: NSDateComponents = calender.components(flags, fromDate: self)
        let compTwo: NSDateComponents = calender.components(flags, fromDate: dateTwo);
        return (compOne.day == compTwo.day && compOne.month == compTwo.month && compOne.year == compTwo.year);
    }
    func secondsFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Second, fromDate: date, toDate: self, options: []).second
    }
}