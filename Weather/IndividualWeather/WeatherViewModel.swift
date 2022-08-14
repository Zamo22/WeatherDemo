//
//  Created by Zaheer Moola on 2022/08/13.
//

import Combine
import Foundation

class WeatherViewModel: ObservableObject {
    private let client: Client
    private let location: Coordinate
    private var subscriptions = Set<AnyCancellable>()

    @Published var currentWeather: CurrentWeather?

    init(withLocation location: Coordinate, client: Client = WeatherClient()) {
        self.location = location
        self.client = client
    }

    func getCurrentWeather() {
        client.fetch(from: .currentWeather(coordinates: location),
                     expectedType: CurrentWeather.self)
        .receive(on: RunLoop.main)
        .sink(receiveCompletion: { [weak self] in
            // Add a different wrapper here to ignore finished
            switch $0 {
            case .failure(let error):
                //todo
                print(error)
            case .finished:
                break
            }
        }, receiveValue: { [weak self] in
            self?.currentWeather = $0
        })
        .store(in: &subscriptions)
    }
}
