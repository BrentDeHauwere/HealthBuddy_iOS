//
//  PatientDashboardController.swift
//  HealthBuddy_iOS
//
//  Created by Yen Jacobs on 17/03/16.
//  Copyright © 2016 Yen Jacobs. All rights reserved.
//

import UIKit
import CircleProgressView

class PatientDashboardController: UIViewController {
    @IBOutlet weak var circleProgressView: CircleProgressView!
    
    var patient:User?;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        self.title = "\(patient!.firstName!) \(patient!.lastName!)";
    }
    
    override func viewDidAppear(animated: Bool) {
        circleProgressView.setProgress(calculateProgress(), animated: true);
    }
    
    // Medicine has to be taken when
    // - Today is between Schedule.start_date and Schedule.end_date
    // - (Today - Schedule.start_date) % Schedule.interval == 0
    
    // Medicine is taken when
    // - Schedule.updated_at == Today ! ================================ TO DO: UPDATED_AT ================================== !
    func calculateProgress() -> Double {
        var medicinesToTake:Int = 0;
        var medicinesTaken:Int = 0;
        
        for medicine in (patient?.medicines)! {
            for schedule in medicine.schedules {
                if NSDate().isBetweeen(date: schedule.start_date!, andDate: schedule.end_date!)
                &&  (NSDate().daysSince1970() - schedule.start_date!.daysSince1970()) % schedule.interval! == 0 {
                    medicinesToTake += 1;
                    if NSCalendar.currentCalendar().compareDate(NSDate(), toDate: schedule.start_date!, toUnitGranularity: .Day) == NSComparisonResult.OrderedSame {
                        medicinesTaken += 1;
                    }
                }
                
            }
        }
        return Double(medicinesTaken)/Double(medicinesToTake);
    }
}

extension NSDate {
    func isBetweeen(date date1: NSDate, andDate date2: NSDate) -> Bool {
        return date1.compare(self).rawValue * self.compare(date2).rawValue >= 0
    }
    
    func daysSince1970() -> Int {
        return (Int)(self.timeIntervalSince1970 / (60*60*24));
    }
    func sameDay(dateTwo:NSDate) -> Bool {
        let calender = NSCalendar.currentCalendar()
        let flags: NSCalendarUnit = [.Day, .Month, .Year]
        let compOne: NSDateComponents = calender.components(flags, fromDate: self)
        let compTwo: NSDateComponents = calender.components(flags, fromDate: dateTwo);
        return (compOne.day == compTwo.day && compOne.month == compTwo.month && compOne.year == compTwo.year);
    }
}