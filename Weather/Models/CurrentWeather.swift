//
//  Created by Zaheer Moola on 2022/08/13.
//

import Foundation

// TODO: Put these sub structs inside CurrentWeather if not reused for other models

struct CurrentWeather: Decodable {
    let coordinates: Coordinate
    let weather: [Weather]
    let temperatures: Temperatures
    let placeId: Int
    let placeName: String

    enum CodingKeys: String, CodingKey {
        case weather
        case coordinates = "coord"
        case temperatures = "main"
        case placeId = "id"
        case placeName = "name"
    }
}

struct Coordinate: Decodable, Hashable {
    let longitude: Double
    let latitude: Double

    enum CodingKeys: String, CodingKey {
        case longitude = "lon", latitude = "lat"
    }
}

struct Weather: Decodable {
    let id: Int
    let main: String
    let description: String
}

struct Temperatures: Decodable {
    let temp: Double
    let feelsLike: Double
    let minTemp: Double
    let maxTemp: Double
    let humidity: Int

    enum CodingKeys: String, CodingKey {
        case temp, humidity, feelsLike = "feels_like", minTemp = "temp_min", maxTemp = "temp_max"
    }
}
