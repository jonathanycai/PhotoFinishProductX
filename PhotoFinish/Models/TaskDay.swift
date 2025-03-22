//
//  TaskDay.swift
//  PhotoFinish
//
//  Created by Renata Liu on 2025-03-22.
//

import SwiftUI

struct TaskDay: Identifiable {
    let id = UUID()
    let date: Date
    let image: UIImage?  // nil if there's no image for that day
}

extension Date {
    /// Returns the first day of the current month
    func startOfMonth(using calendar: Calendar = .current) -> Date {
        let components = calendar.dateComponents([.year, .month], from: self)
        return calendar.date(from: components)!
    }

    /// Returns the number of days in the month
    func daysInMonth(using calendar: Calendar = .current) -> Int {
        guard let range = calendar.range(of: .day, in: .month, for: self) else { return 30 }
        return range.count
    }

    /// Returns the weekday (1 = Sunday, 2 = Monday, ...) of the current date
    func weekday(using calendar: Calendar = .current) -> Int {
        return calendar.component(.weekday, from: self)
    }
}

func generateMonthDays(for date: Date,
                       imagesByDate: [Date: UIImage] = [:],
                       calendar: Calendar = .current) -> [TaskDay] {
    let startOfMonth = date.startOfMonth(using: calendar)
    let totalDays = date.daysInMonth(using: calendar)
    let firstWeekday = calendar.component(.weekday, from: startOfMonth)
    
    var days: [TaskDay] = []
    
    // adding blanks for empty days
    let blanksCount = firstWeekday - 1  // how many placeholders
    for _ in 0..<blanksCount {
        days.append(TaskDay(date: Date.distantPast, image: nil)) // placeholder
    }

    // creating a taskday for each actual day
    for dayOffset in 0..<totalDays {
        guard let currentDay = calendar.date(byAdding: .day, value: dayOffset, to: startOfMonth) else { continue }
        let image = imagesByDate[currentDay] // if you have a dictionary of images
        days.append(TaskDay(date: currentDay, image: image))
    }

    return days
}

