//
//  TodoItem.swift
//  TodoNotificationsTutorial
//

import Foundation

struct TodoItem {
    var title: String
    var deadline: NSDate
    var UUID: String
    var medicine: Medicine
    var medicalSchedule: MedicalSchedule
    
    init(deadline: NSDate, title: String, UUID: String, medicine: Medicine, medicalSchedule: MedicalSchedule) {
        self.deadline = deadline
        self.title = title
        self.UUID = UUID
        self.medicine = medicine
        self.medicalSchedule = medicalSchedule
    }
    
    var isOverdue: Bool {
        return (NSDate().compare(self.deadline) == NSComparisonResult.OrderedDescending)
    }
    
    var toString: String {
        return "deadline: \(self.deadline)\r\ntitle:\(self.title)\r\nUUID:\(self.UUID)\r\nmedicine:\(self.medicine.name!)\r\nmedicalschedule:\(self.medicalSchedule.start_date!)\r\ninterval:\(self.medicalSchedule.interval!)\r\n\r\n"
    }
}