//
//  Created by Zaheer Moola on 2022/08/13.
//

import Combine
import Foundation

class WeatherViewModel: ObservableObject {
    private let client: Client
    private let locationManager: Locatable
    private var subscriptions = Set<AnyCancellable>()

    var currentLocation: Coordinate?

    @Published var currentWeather: CurrentWeather?

    init(withClient client: Client = WeatherClient(),
         locationManager: Locatable = LocationManager()) {
        self.client = client
        self.locationManager = locationManager
    }

    func getWeather() {
        
//        getCurrentWeather(using: currentLocation)
    }


    private func getCurrentWeather(using location: Coordinate) {
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
