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
            .decode(type: T.self, decoder: decoder)
            .eraseToAnyPublisher()
    }

    var decoder: JSONDecoder {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        return decoder
    }
}
