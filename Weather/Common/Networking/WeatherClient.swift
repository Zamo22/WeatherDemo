//
//  Created by Zaheer Moola on 2022/08/13.
//

import Foundation
import Combine

protocol Client {
    func fetch<T: Decodable>(from endpoint: Endpoint, expectedType: T.Type) -> AnyPublisher<T, Error>
}

class WeatherClient: Client {
    func fetch<T: Decodable>(from endpoint: Endpoint, expectedType: T.Type) -> AnyPublisher<T, Error> {
        URLSession.shared.dataTaskPublisher(for: endpoint.url)
            .map {$0.data}
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
