//
//  Created by Zaheer Moola on 2022/08/15.
//

import Foundation

extension UserDefaults {
    var unitOfMeasurement: UnitMeasurement {
        get {
            let value = self.string(forKey: Constants.Storage.weatherMeasurementKey)
            return UnitMeasurement(rawValue: value ?? "") ?? .metric
        }
        set {
            self.set(newValue.rawValue, forKey: Constants.Storage.weatherMeasurementKey)
        }
    }
}
