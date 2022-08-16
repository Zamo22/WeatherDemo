//
//  Created by Zaheer Moola on 2022/08/16.
//

import Foundation

enum WeatherError {
    case locationPermission
    case fetchingData
    case generic

    var description: String {
        switch self {
        case .locationPermission:
            return "Location permission denied. Please rectify this in your device settings"
        case .fetchingData:
            return "Error fetching data"
        case .generic:
            return "An error occurred"
        }
    }
}

enum ViewState {
    case error(_: WeatherError)
    case loading
    case loaded(data: Any)
}
