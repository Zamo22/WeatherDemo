//
//  Created by Zaheer Moola on 2022/08/13.
//

import Foundation

/* Note: This class is just something I threw together based on https://www.swiftbysundell.com/clips/4/
and could use a lot of work if used on a large scale */

enum Endpoint {
    case currentWeather(coordinates: Coordinate)
    case forecast(coordinates: Coordinate)
}

// MARK: - URL Construction
extension Endpoint {
    private var path: String {
        switch self {
        case .currentWeather:
            return "data/2.5/weather"
        case .forecast:
            return "data/2.5/forecast"
        }
    }

    private var queryParameters: [URLQueryItem] {
        switch self {
        case .currentWeather(let coordinates):
            return createQueryItemsForCoordinates(coordinates)
        case .forecast(let coordinates):
            return createQueryItemsForCoordinates(coordinates)
        }
    }

    private func createQueryItemsForCoordinates(_ coordinates: Coordinate) -> [URLQueryItem] {
        [URLQueryItem(name: Constants.Endpoints.latitudeKey, value: String(coordinates.latitude)),
         URLQueryItem(name: Constants.Endpoints.longitudeKey, value: String(coordinates.longitude)),
         URLQueryItem(name: Constants.Endpoints.unitsKey, value: UserDefaults.standard.unitOfMeasurement.rawValue)]
    }

    var url: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = Constants.Endpoints.baseUrl
        components.path = "/" + path
        components.queryItems = queryParameters.addingDefaultApiKey()

        guard let url = components.url else {
            preconditionFailure("Invalid parameters provided: \(components)")
        }
        return url
    }
}

// MARK: - Wrapper for adding api key to all requests
private extension Array where Element == URLQueryItem {
    func addingDefaultApiKey() -> Self {
        var items = self
        items.append(URLQueryItem(name: Constants.Endpoints.appIdKey,
                                  value: Constants.Endpoints.openWeatherApiKey))
        return items
    }
}
