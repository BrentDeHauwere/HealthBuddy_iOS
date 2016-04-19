//
//  NotificationController.swift
//  HealthBuddy_iOS
//
//  Created by Kamiel Klumpers on 19/04/16.
//  Copyright © 2016 Yen Jacobs. All rights reserved.
//

import Foundation

class NotificationController : NSObject {
    static func updateToDoList(schedules: [MedicalSchedule]){
        
        /* Properties MedicalSchedule
         var id:Int?
         var medicineId:Int?
         var time: String?;
         var amount: String?;
         var interval: Int?;
         var start_date_s:String?;
         var end_date_s:String?;
         var start_date:NSDate?;
         var end_date:NSDate?; */
        
        for schedule in schedules {
            // schedule 1 week in advance
            let weeksInAdvance = 1;
            
            let now = NSDate.init();
            if let started = schedule.start_date?.isBeforeDate(now), let ended = schedule.end_date?.isAfterDate(now){
                if started && !ended {
                    let message : NSDate
                    let medicijn = 
                    let text = "Neem \"\(started)\" Is Overdue"
                    let todoItem = TodoItem(deadline: date, title: message, UUID: NSUUID().UUIDString)
                }
            }
            
            /*
            let todoItem = TodoItem(deadline: schedule., title: titleField.text!, UUID: NSUUID().UUIDString)
            TodoList.sharedInstance.addItem(todoItem) // schedule a local notification to persist this item
            */
        }
    }
}

// extension functions to NSDate
// src: 
// http://stackoverflow.com/questions/26198526/nsdate-comparison-using-swift
extension NSDate {
    // 'this' comes after dateToCompare
    func isAfterDate(dateToCompare: NSDate) -> Bool {
        var isGreater = false
        if self.compare(dateToCompare) == NSComparisonResult.OrderedDescending {
            isGreater = true
        }
        return isGreater
    }
    
    // 'this' comes before dateToCompare
    func isBeforeDate(dateToCompare: NSDate) -> Bool {
        var isLess = false
        if self.compare(dateToCompare) == NSComparisonResult.OrderedAscending {
            isLess = true
        }
        return isLess
    }
    
    func equalToDate(dateToCompare: NSDate) -> Bool {
        var isEqualTo = false
        if self.compare(dateToCompare) == NSComparisonResult.OrderedSame {
            isEqualTo = true
        }
        return isEqualTo
    }
    
    func addDays(daysToAdd: Int) -> NSDate {
        let secondsInDays: NSTimeInterval = Double(daysToAdd) * 60 * 60 * 24
        let dateWithDaysAdded: NSDate = self.dateByAddingTimeInterval(secondsInDays)
        return dateWithDaysAdded
    }
    
    func addHours(hoursToAdd: Int) -> NSDate {
        let secondsInHours: NSTimeInterval = Double(hoursToAdd) * 60 * 60
        let dateWithHoursAdded: NSDate = self.dateByAddingTimeInterval(secondsInHours)
        return dateWithHoursAdded
    }
}