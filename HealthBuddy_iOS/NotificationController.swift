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
        let qualityOfServiceClass = QOS_CLASS_BACKGROUND
        let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
        dispatch_async(backgroundQueue, {
            
            if let medicines = user.medicines {
                for medicine in medicines {
                    updateMedicalSchedules(medicine, schedules: medicine.schedules)
                }
            }
            
        })
    }
    
    private static func updateMedicalSchedules(medicine: Medicine, schedules: [MedicalSchedule]){
        
        let cal = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let now = NSDate();
        
        for schedule in schedules {
            if let end = schedule.end_date {
                if end.isAfterDate(now){
                    
                    // calculate timespans (in days)
                    let startToNow = daysBetween(schedule.start_date!, end: now)
                    
                    // days in the future the next schedule needs to be made
                    let daysInFuture = schedule.interval! - (startToNow % schedule.interval!)
                    
                    var nextScheduleDate: NSDate = now;
                    
                    if(startToNow % schedule.interval! != 0){
                        nextScheduleDate = nextScheduleDate.addDays(daysInFuture)
                    }
                    
                    // set time for the schedule
                    let unitFlags: NSCalendarUnit = [.Minute, .Hour, .Day, .Month, .Year]
                    let scheduleComponents = NSCalendar.currentCalendar().components(unitFlags, fromDate: nextScheduleDate)
                    
                    // getting time from time String
                    let format = NSDateFormatter()
                    format.dateFormat = "HH:mm:ss"
                    format.timeZone = NSTimeZone(abbreviation: "GMT+00:00")
                    
                    let dateFromString = format.dateFromString(schedule.time_s!)!
                    
                    let time = NSCalendar.currentCalendar().components(unitFlags, fromDate: dateFromString )
                    
                    scheduleComponents.hour = time.hour
                    scheduleComponents.minute = time.minute
                    scheduleComponents.timeZone = NSTimeZone(abbreviation: "GMT+01:00")
                    
                    var scheduleDate = cal.dateFromComponents(scheduleComponents)
                    
                    if((scheduleDate?.isBeforeDate(now)) != nil){
                        scheduleDate?.addDays(schedule.interval!)
                    }
                    
                    // amount of times scheduled (in the next {{daysInAdvance}} days)
                    for _ in 1...3 {
                        if scheduleDate?.isBeforeDate(end) != nil && (scheduleDate?.isBeforeDate(end))! {
                            print("\(medicine.name!) \(scheduleDate!)")
                            
                            let message = "\(medicine.name!): \(schedule.amount!)"
                            let todoItem = TodoItem(deadline: scheduleDate!, title: message, UUID: NSUUID().UUIDString)
                            TodoList.sharedInstance.addItem(todoItem)
                            scheduleDate = scheduleDate!.addDays(schedule.interval!)
                        } else {
                            break
                        }
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
    
    func addDays(daysToAdd: Int) -> NSDate {
        let secondsInDays: NSTimeInterval = Double(daysToAdd) * 60 * 60 * 24
        let dateWithDaysAdded: NSDate = self.dateByAddingTimeInterval(secondsInDays)
        return dateWithDaysAdded
    }
    
}