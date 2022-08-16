//
//  Created by Zaheer Moola on 2022/08/15.
//

import Foundation

enum UnitMeasurement: String, CaseIterable, Identifiable {
    case metric
    case imperial

    var id: UnitMeasurement { self }

    var commonName: String {
        switch self {
        case .metric:
            return "Celcius"
        case .imperial:
            return "Fahrenheit"
        }
    }
}
