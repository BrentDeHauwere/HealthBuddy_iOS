//
//  TodoList.swift

import Foundation
import UIKit

class TodoList {
    class var sharedInstance : TodoList {
        struct Static {
            static let instance : TodoList = TodoList()
        }
        return Static.instance
    }
    
    private let ITEMS_KEY = "todoItems"
    
    func allItems() -> [TodoItem] {
        let todoDictionary = NSUserDefaults.standardUserDefaults().dictionaryForKey(ITEMS_KEY) ?? [:]
        let items = Array(todoDictionary.values)
        return items.map({TodoItem(deadline: $0["deadline"] as! NSDate, title: $0["title"] as! String, UUID: $0["UUID"] as! String!, medicine: $0["medicine"] as! Medicine, medicalSchedule: $0["medicalSchedule"] as! MedicalSchedule)}).sort({(left: TodoItem, right:TodoItem) -> Bool in
            (left.deadline.compare(right.deadline) == .OrderedAscending)
        })
    }
    
    func addItem(item: TodoItem) {
        // persist a representation of this todo item in NSUserDefaults
        var todoDictionary = NSUserDefaults.standardUserDefaults().dictionaryForKey(ITEMS_KEY) ?? Dictionary() // if todoItems hasn't been set in user defaults, initialize todoDictionary to an empty dictionary using nil-coalescing operator (??)
        
        
        /*  dingen nodig:
         medicine_id
         medicine_name
         medicine_info
         
         medicalschedule_id
         medicalschedule_time
         */
        
        
        // store NSData representation of todo item in dictionary with UUID as key
        todoDictionary[item.UUID] =
            ["deadline": item.deadline,
             "title": item.title,
             "UUID": item.UUID,
             "medicine_id": "\(item.medicine.id!)",
             "medicine_name": item.medicine.name!,
             "medicine_info": item.medicine.info!,
             "medicalschedule_id": "\(item.medicalSchedule.id!)",
             "medicalschedule_time": item.medicalSchedule.time!]
        
        NSUserDefaults.standardUserDefaults().setObject(todoDictionary, forKey: ITEMS_KEY) // save/overwrite todo item list
        
        
        // create a corresponding local notification
        let notification = UILocalNotification()
        notification.fireDate = item.deadline // todo item due date (when notification will be fired)
        notification.alertBody = "\(notification.fireDate) \(item.title)" // text that will be displayed in the notification
        notification.alertAction = "open" // text that is displayed after "slide to..." on the lock screen - defaults to "slide to view"
        notification.soundName = UILocalNotificationDefaultSoundName // play default sound
        notification.userInfo = ["title": item.title, "UUID": item.UUID] // assign a unique identifier to the notification so that we can retrieve it later
        
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    func clear(){
        let notifications = UIApplication.sharedApplication().scheduledLocalNotifications! as [UILocalNotification]
        
        for not in notifications {
            // clear notifications from the OS
            UIApplication.sharedApplication().cancelLocalNotification(not)
        }
        
        // overwrite list of items with empty one
        NSUserDefaults.standardUserDefaults().setObject(nil, forKey: ITEMS_KEY)
        
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0
    }
    
    func removeItem(item: TodoItem) {
        for notification in UIApplication.sharedApplication().scheduledLocalNotifications! as [UILocalNotification] { // loop through notifications...
            if (notification.userInfo!["UUID"] as! String == item.UUID) { // ...and cancel the notification that corresponds to this TodoItem instance (matched by UUID)
                UIApplication.sharedApplication().cancelLocalNotification(notification) // there should be a maximum of one match on UUID
                break
            }
        }
        
        if var todoItems = NSUserDefaults.standardUserDefaults().dictionaryForKey(ITEMS_KEY) {
            todoItems.removeValueForKey(item.UUID)
            NSUserDefaults.standardUserDefaults().setObject(todoItems, forKey: ITEMS_KEY) // save/overwrite todo item list
        }
    }
    
}