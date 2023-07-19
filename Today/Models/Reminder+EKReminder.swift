//
//  Reminder+EKReminder.swift
//  Today
//
//  Created by Aleksandr on 19.07.2023.
//

import Foundation
import EventKit

extension Reminder {
    init(with ekReminder: EKReminder) throws {
        guard let ekDueDate = ekReminder.alarms?.first?.absoluteDate else {
            throw TodayError.reminderHasNoDueDate
        }
        id = ekReminder.calendarItemIdentifier
        title = ekReminder.title
        notes = ekReminder.notes
        dueDate = ekDueDate
        isComplete = ekReminder.isCompleted
    }
}
