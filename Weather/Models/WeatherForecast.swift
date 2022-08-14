//
//  Created by Zaheer Moola on 2022/08/14.
//

import Foundation

struct WeatherForecast: Decodable {
    let list: [WeatherForecastItem]
    let city: City?

    struct City: Decodable {
        let id: Int
        let name: String
    }
}

struct WeatherForecastItem: Decodable {
    let temperatures: Temperatures
    let weather: [Weather]
    let forecastTime: Date

    var weatherCondition: WeatherCondition {
        let weatherCode = weather.first?.id ?? 0
        return WeatherCondition.build(fromCode: weatherCode)
    }

    enum CodingKeys: String, CodingKey {
        case weather, temperatures = "main", forecastTime = "dt_txt"
    }
}
