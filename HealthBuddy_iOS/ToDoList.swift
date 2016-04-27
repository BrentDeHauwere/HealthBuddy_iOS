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
        return items.map({TodoItem(deadline: $0["deadline"] as! NSDate, title: $0["title"] as! String, UUID: $0["UUID"] as! String!)}).sort({(left: TodoItem, right:TodoItem) -> Bool in
            (left.deadline.compare(right.deadline) == .OrderedAscending)
        })
    }
    
    func addItem(item: TodoItem) {
        // persist a representation of this todo item in NSUserDefaults
        var todoDictionary = NSUserDefaults.standardUserDefaults().dictionaryForKey(ITEMS_KEY) ?? Dictionary() // if todoItems hasn't been set in user defaults, initialize todoDictionary to an empty dictionary using nil-coalescing operator (??)
        todoDictionary[item.UUID] = ["deadline": item.deadline, "title": item.title, "UUID": item.UUID] // store NSData representation of todo item in dictionary with UUID as key
        NSUserDefaults.standardUserDefaults().setObject(todoDictionary, forKey: ITEMS_KEY) // save/overwrite todo item list
        
        // create a corresponding local notification
        let notification = UILocalNotification()
        notification.alertBody = item.title // text that will be displayed in the notification
        notification.alertAction = "open" // text that is displayed after "slide to..." on the lock screen - defaults to "slide to view"
        notification.fireDate = item.deadline // todo item due date (when notification will be fired)
        notification.soundName = UILocalNotificationDefaultSoundName // play default sound
        notification.userInfo = ["title": item.title, "UUID": item.UUID] // assign a unique identifier to the notification so that we can retrieve it later
        
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
        
        self.setBadgeNumbers()
    }
    
    func clear(){
        let notifications = UIApplication.sharedApplication().scheduledLocalNotifications! as [UILocalNotification]
        
        for not in notifications {
            // clear notifications from the OS
            UIApplication.sharedApplication().cancelLocalNotification(not)
        }
        
        // overwrite list of items with empty one
        NSUserDefaults.standardUserDefaults().setObject(nil, forKey: ITEMS_KEY)
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
        self.setBadgeNumbers()
    }
    
    func setBadgeNumbers() {
        let notifications = UIApplication.sharedApplication().scheduledLocalNotifications! as [UILocalNotification] // all scheduled notifications
        let todoItems: [TodoItem] = self.allItems()
        for notification in notifications {
            let overdueItems = todoItems.filter({ (todoItem) -> Bool in // array of to-do items...
                return (todoItem.deadline.compare(notification.fireDate!) != .OrderedDescending) // ...where item deadline is before or on notification fire date
            })
            UIApplication.sharedApplication().cancelLocalNotification(notification) // cancel old notification
            notification.applicationIconBadgeNumber = overdueItems.count // set new badge number
            UIApplication.sharedApplication().scheduleLocalNotification(notification) // reschedule notification
        }
    }
    
}