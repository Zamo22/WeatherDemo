//
//  Created by Zaheer Moola on 2022/08/15.
//

import Foundation

extension Date {
    var isToday: Bool {
        Calendar.current.isDateInToday(self)
    }

    var hour: Int {
        Calendar.current.component(.hour, from: self)
    }

    var day: String {
        DateFormatter()
            .weekdaySymbols[Calendar.current.component(.weekday, from: self)]
    }
}
