//
//  Created by Zaheer Moola on 2022/08/14.
//

import Foundation
import Combine

extension WeatherViewModel {
    static let preview: WeatherViewModel = {
        let defaultCoordinate = Coordinate(latitude: 0, longitude: 0)
        return WeatherViewModel(withLocation: defaultCoordinate, client: PreviewClient(),
                                isCurrentLocation: true)
    }()
}

fileprivate class PreviewClient: Client {
    func fetch<T: Decodable>(from endpoint: Endpoint, expectedType: T.Type) -> AnyPublisher<T, Error> {
        let resource = expectedType == CurrentWeather.self ? "currentWeather" : "weatherForecast"
        let decoder = WeatherClient().decoder

        guard let path = Bundle.main.url(forResource: resource, withExtension: "json") ,
              let data = try? Data(contentsOf: path),
                let model = try? decoder.decode(expectedType, from: data) else {
            return Fail(error: NSError(domain: "", code: -1)).eraseToAnyPublisher()
        }
        return Just(model)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
