//
//  NotificationController.swift
//
//  Source of information about notifications:
//  http://jamesonquave.com/blog/local-notifications-in-ios-8-with-swift-part-1/

import Foundation

class NotificationController : NSObject {
    
    static func getTodoList() -> TodoList{
        return TodoList.sharedInstance
    }
    
    static func updateMedicines(user: User){
        if let medicines = user.medicines {
            for medicine in medicines {
                updateMedicalSchedules(medicine.schedules)
            }
        }
    }
    
    private static func updateMedicalSchedules(schedules: [MedicalSchedule]){
        
        let cal = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let now = NSDate();
        
        for schedule in schedules {
            if let end = schedule.end_date {
                if end.isAfterDate(now){
                    print(schedule.description)
                    
                    // calculate timespans (in days)
                    let startToNow = daysBetween(schedule.start_date!, end: now)
                    
                    // days in the future the next schedule needs to be made
                    let daysInFuture = 3 - (startToNow % 3)
                    print("dagen in toekomst: \(daysInFuture)")
                    
                    var nextScheduleDate: NSDate = now;
                    nextScheduleDate = nextScheduleDate.addDays(daysInFuture)
                    
                    // set time for the schedule
                    let unitFlags: NSCalendarUnit = [.Minute, .Hour, .Day, .Month, .Year]
                    let scheduleComponents = NSCalendar.currentCalendar().components(unitFlags, fromDate: nextScheduleDate)
                    
                    // getting time from time String
                    let format = NSDateFormatter()
                    format.dateFormat = "HH:mm:ss"
                    format.timeZone = NSTimeZone(abbreviation: "GMT")
                    
                    let dateFromString = format.dateFromString(schedule.time_s!)!
                    
                    print("dateFromString: \(dateFromString)")
                    
                    let time = NSCalendar.currentCalendar().components(unitFlags, fromDate: dateFromString )
                    
                    scheduleComponents.hour = time.hour
                    scheduleComponents.minute = time.minute
                    scheduleComponents.timeZone = NSTimeZone(abbreviation: "GMT+01:00")
                    
                    var scheduleDate = cal.dateFromComponents(scheduleComponents)
                    
                    print(scheduleDate)
                    
                    // amount of times scheduled (in the next {{daysInAdvance}} days)
                    repeat {
                        print("scheduleDate: \(scheduleDate!)")
                        
                        scheduleDate = scheduleDate?.addDays(schedule.interval!)
                        
                        let message = "\(schedule.amount)"
                        let todoItem = TodoItem(deadline: scheduleDate!, title: message, UUID: NSUUID().UUIDString)
                        TodoList.sharedInstance.addItem(todoItem)
                        scheduleDate = scheduleDate!.addDays(schedule.interval!)
                        
                    } while scheduleDate?.isBeforeDate(end) != nil && (scheduleDate?.isBeforeDate(end))!
                    
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
    
    func addDays(daysToAdd: Int) -> NSDate {
        let secondsInDays: NSTimeInterval = Double(daysToAdd) * 60 * 60 * 24
        let dateWithDaysAdded: NSDate = self.dateByAddingTimeInterval(secondsInDays)
        return dateWithDaysAdded
    }
    
}