//
//  Created by Zaheer Moola on 2022/08/15.
//

import Foundation
import Combine

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

class SettingsViewModel: ObservableObject {
    let defaults: UserDefaults
    @Published var unitOfMeasurement: UnitMeasurement

    private var subscriptions = Set<AnyCancellable>()

    init(userDefaults: UserDefaults = UserDefaults.standard) {
        self.defaults = userDefaults
        self.unitOfMeasurement = userDefaults.unitOfMeasurement
        $unitOfMeasurement
            .dropFirst()
            .sink(receiveValue: {
            self.defaults.unitOfMeasurement = $0
        })
        .store(in: &subscriptions)
    }
}
