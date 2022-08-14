//
//  Created by Zaheer Moola on 2022/08/14.
//

import Foundation
import Combine

extension WeatherViewModel {
    static let preview: WeatherViewModel = {
        let defaultCoordinate = Coordinate(latitude: 0, longitude: 0)
        return WeatherViewModel(withLocation: defaultCoordinate, client: PreviewClient())
    }()
}

fileprivate class PreviewClient: Client {
    func fetch<T: Decodable>(from endpoint: Endpoint, expectedType: T.Type) -> AnyPublisher<T, Error> {
        // let model = try? JSONDecoder().decode(expectedType, from: data)
        guard let path = Bundle.main.url(forResource: "currentWeather", withExtension: "json") ,
              let data = try? Data(contentsOf: path),
                let model = try? JSONDecoder().decode(expectedType, from: data) else {
            return Fail(error: NSError(domain: "", code: -1)).eraseToAnyPublisher()
        }
        return Just(model)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
