//
//  Created by Zaheer Moola on 2022/08/13.
//

import Foundation

enum Constants {
    enum Endpoints {
        static let baseUrl = "api.openweathermap.org"
        static let latitudeKey = "lat"
        static let longitudeKey = "lon"
        static let unitsKey = "units"
        static let appIdKey = "appid"

        // For simplicity purposes, keeping this exposed 
        static let openWeatherApiKey = "0bfd9c5cc36733700fcb9101b9fd4596"
    }

    enum Storage {
        static let weatherMeasurementKey = "weatherMeasurement"
    }
}
