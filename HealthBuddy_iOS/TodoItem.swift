//
//  ToDoItem.swift
//  HealthBuddy_iOS
//
//  Created by Kamiel Klumpers on 19/04/16.
//  Copyright © 2016 Yen Jacobs. All rights reserved.
//
//  src information: http://jamesonquave.com/blog/local-notifications-in-ios-8-with-swift-part-1/
//  and: http://jamesonquave.com/blog/local-notifications-in-ios-8-with-swift-part-2/


import Foundation

struct TodoItem {
    var title: String
    var deadline: NSDate
    var UUID: String
    
    init(deadline: NSDate, title: String, UUID: String) {
        self.deadline = deadline
        self.title = title
        self.UUID = UUID
    }
    
    var isOverdue: Bool {
        return (NSDate().compare(self.deadline) == NSComparisonResult.OrderedDescending)
    }
}