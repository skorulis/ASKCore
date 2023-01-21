//  Created by Alexander Skorulis on 2/10/2022.

import Foundation

public extension Date {
    var startOfMonth: Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    /// First monday of the week
    var startOfWeek: Date {
        var calendar = Calendar.current
        calendar.firstWeekday = 2
        return calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: calendar.startOfDay(for: self)))!
    }
    
    func adding(days: Int) -> Date {
        let components = DateComponents(day: days)
        return Calendar.current.date(byAdding: components, to: self)!
    }
    
}
