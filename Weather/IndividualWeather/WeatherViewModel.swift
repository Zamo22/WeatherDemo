//
//  Created by Zaheer Moola on 2022/08/13.
//

import Combine
import Foundation

enum WeatherViewState {
    case loading
    case error
    case loaded(currentWeather: CurrentWeather,
                forecast: [WeatherForecastItem])
}

class WeatherViewModel: ObservableObject {
    private let client: Client
    private let location: Coordinate
    private var subscriptions = Set<AnyCancellable>()

    @Published var weatherViewState: WeatherViewState = .loading

    init(withLocation location: Coordinate, client: Client = WeatherClient()) {
        self.location = location
        self.client = client
    }

    func getWeather() {
        getCurrentWeather()
            .combineLatest(getWeatherForecast())
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { [weak self] in
                switch $0 {
                case .failure:
                    self?.weatherViewState = .error
                case .finished: break
                }
            }, receiveValue: { [weak self] current, forecast in
                self?.weatherViewState = .loaded(currentWeather: current, forecast: forecast)
            })
            .store(in: &subscriptions)
    }

    private func getCurrentWeather() -> AnyPublisher<CurrentWeather, Error>{
        client.fetch(from: .currentWeather(coordinates: location),
                     expectedType: CurrentWeather.self)
    }

    private func getWeatherForecast() -> AnyPublisher<[WeatherForecastItem], Error> {
        client.fetch(from: .forecast(coordinates: location),
                     expectedType: WeatherForecast.self)
        .map { $0.list
                .filter { steppedForecast in
                    let date = steppedForecast.forecastTime
                    let hour = date.hour
                    return hour >= 11 && hour <= 13 && !date.isToday
                }
        }
        .replaceError(with: [])
        .setFailureType(to: Error.self)
        .eraseToAnyPublisher()
    }
}
