//  Created by Alexander Skorulis on 2/10/2022.

import Foundation

public extension Date {
    var startOfMonth: Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
}
