//  Created by Alexander Skorulis on 11/12/2022.

import Foundation
import XCTest
@testable import ASKCore

final class DateAdditionTests: XCTestCase {
    
    func test_startOfWeek() {
        let date1 = formatter.date(from: "11/12/2022")!
        let expected1 = formatter.date(from: "05/12/2022")!
        XCTAssertEqual(date1.startOfWeek, expected1)
        
        let date2 = formatter.date(from: "12/12/2022")!
        let expected2 = formatter.date(from: "12/12/2022")!
        XCTAssertEqual(date2.startOfWeek, expected2)
    }
    
    
    private lazy var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()
}
