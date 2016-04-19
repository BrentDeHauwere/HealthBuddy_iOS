//
//  ToDoList.swift
//  HealthBuddy_iOS
//
//  Created by Kamiel Klumpers on 19/04/16.
//  Copyright © 2016 Yen Jacobs. All rights reserved.
//
//  src information: http://jamesonquave.com/blog/local-notifications-in-ios-8-with-swift-part-1/
//  and: http://jamesonquave.com/blog/local-notifications-in-ios-8-with-swift-part-2/

import Foundation
import UIKit

class ToDoList {
    // singleton for keeping the medicine-notifications
    class var sharedInstance : ToDoList {
        struct Static {
            static let instance : ToDoList = ToDoList()
        }
        return Static.instance
    }
    
    // key for initializing dictionaries
    private let ITEMS_KEY = "todoItems"
    
    // get all the ToDoItems (medicines) in a dictionary sorted chronologically
    func allItems() -> [TodoItem] {
        let todoDictionary = NSUserDefaults.standardUserDefaults().dictionaryForKey("toDoItems") ?? [:]
        let items = Array(todoDictionary.values)
        return items.map(
            {TodoItem(deadline: $0["deadline"] as! NSDate, title: $0["title"] as! String, UUID: $0["UUID"] as! String!)}).sort({(left: TodoItem, right:TodoItem) -> Bool in
            (left.deadline.compare(right.deadline) == .OrderedAscending)
        })
    }
    
    func addItem(item: TodoItem) {
        // persist a representation of this todo item in NSUserDefaults
        var todoDictionary = NSUserDefaults.standardUserDefaults().dictionaryForKey(ITEMS_KEY) ?? Dictionary()
        
        // if todoItems hasn't been set in user defaults, initialize todoDictionary to an empty dictionary using nil-coalescing operator
        todoDictionary[item.UUID] = ["deadline": item.deadline, "title": item.title, "UUID": item.UUID]
        
        // store NSData representation of todo item in dictionary with UUID as key
        NSUserDefaults.standardUserDefaults().setObject(todoDictionary, forKey: ITEMS_KEY) // save/overwrite todo item list
        
        // create a corresponding local notification
        let notification = UILocalNotification()
        notification.alertBody = item.title
        notification.alertAction = "open"
        notification.fireDate = item.deadline
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.userInfo = ["title": item.title, "UUID": item.UUID]
        
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    func removeItem(item: TodoItem) {
        for notification in UIApplication.sharedApplication().scheduledLocalNotifications! as [UILocalNotification] {
            
            if (notification.userInfo!["UUID"] as! String == item.UUID) {
                UIApplication.sharedApplication().cancelLocalNotification(notification)
                break
            }
        }
        
        if var todoItems = NSUserDefaults.standardUserDefaults().dictionaryForKey(ITEMS_KEY) {
            todoItems.removeValueForKey(item.UUID)
            NSUserDefaults.standardUserDefaults().setObject(todoItems, forKey: ITEMS_KEY) // save/overwrite todo item list
        }
    }
    
    func setBadgeNumbers() {
        // scheduled notifications
        let notifications = UIApplication.sharedApplication().scheduledLocalNotifications! as [UILocalNotification]
        let todoItems: [TodoItem] = self.allItems()
        for notification in notifications {
            let overdueItems = todoItems.filter({ (todoItem) -> Bool in // array of to-do items...
                return (todoItem.deadline.compare(notification.fireDate!) != .OrderedDescending)
            })
            UIApplication.sharedApplication().cancelLocalNotification(notification) // cancel old notification
            notification.applicationIconBadgeNumber = overdueItems.count // set new badge number
            UIApplication.sharedApplication().scheduleLocalNotification(notification) // reschedule notification
        }
    }
    
}