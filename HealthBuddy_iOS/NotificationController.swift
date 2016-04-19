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
        
        let cal = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        
        for schedule in schedules {
            // schedule 2 weeks in advance
            let daysInAdvance = 14;
            
            let now = NSDate();
            let future = now.addDays(daysInAdvance);
            
            if let started = schedule.start_date?.isBeforeDate(future), let ended = schedule.end_date?.isAfterDate(now){
                if started && !ended {
                    
                    // calculate timespans (in days)
                    let startToNow = daysBetween(schedule.start_date!, end: now)
                    
                    // days in the future the next schedule needs to be made
                    let daysInFuture = 3 - (startToNow % 3)
                    
                    let nextScheduleDate: NSDate = now;
                    nextScheduleDate.addDays(daysInFuture)
                    
                    // set time for the schedule
                    let unitFlags: NSCalendarUnit = [.Minute, .Hour, .Day, .Month, .Year]
                    let scheduleComponents = NSCalendar.currentCalendar().components(unitFlags, fromDate: nextScheduleDate)
                    
                    // getting time from time String
                    let format = NSDateFormatter()
                    format.dateFormat = "HH:mm:ss"
                    let dateFromString = format.dateFromString(schedule.time_s!)!
                    
                    let time = NSCalendar.currentCalendar().components(unitFlags, fromDate: dateFromString )
                    
                    scheduleComponents.hour = time.hour
                    scheduleComponents.minute = time.minute
                    let scheduleDate = cal.dateFromComponents(scheduleComponents)
                    
                    // amount of times scheduled (in the next {{daysInAdvance}} days)
                    let times = Int(floor(Double(daysInAdvance)/Double(schedule.interval!)))
                    
                    for _ in 1...times {
                        // placeholder
                        let medicine : Medicine = Medicine(id:-20, name: "testMedicijn", photo:nil)
                        
                        let message = "Neem \(medicine.name) (\(schedule.amount)x)"
                        let todoItem = TodoItem(deadline: scheduleDate!, title: message, UUID: NSUUID().UUIDString)
                        ToDoList.sharedInstance.addItem(todoItem)
                        
                        scheduleDate!.addDays(schedule.interval!)
                    }
                    
                }
            }

        }
    }
    
    private static func daysBetween(let start: NSDate, let end: NSDate) -> Int{
        let calendar: NSCalendar = NSCalendar.currentCalendar()
        let date1 = calendar.startOfDayForDate(start)
        let date2 = calendar.startOfDayForDate(end)
        let flags = NSCalendarUnit.Day
        let dayComponent = calendar.components(flags, fromDate: date1, toDate: date2, options: [])
        return dayComponent.day
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