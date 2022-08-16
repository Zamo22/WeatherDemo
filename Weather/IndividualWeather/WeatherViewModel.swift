//
//  Created by Zaheer Moola on 2022/08/13.
//

import Combine
import Foundation

class WeatherViewModel: ObservableObject {
    private let client: Client
    private let savedLocationService: SavedLocationsProvider
    private let location: Coordinate
    private var subscriptions = Set<AnyCancellable>()

    @Published var weatherViewState: ViewState = .loading
    @Published var showBookmarkButton: Bool

    init(withLocation location: Coordinate,
         client: Client = WeatherClient(),
         saveLocationService: SavedLocationsProvider = SavedLocationsService(),
         isCurrentLocation: Bool) {
        self.location = location
        self.client = client
        self.savedLocationService = saveLocationService
        self.showBookmarkButton = isCurrentLocation
        getWeather()
    }

    func getWeather() {
        getCurrentWeather()
            .zip(getWeatherForecast())
            .sink(receiveCompletion: { [weak self] in
                switch $0 {
                case .failure:
                    self?.weatherViewState = .error(.fetchingData)
                case .finished: break
                }
            }, receiveValue: { [weak self] current, forecast in
                self?.weatherViewState = .loaded(data: (current: current, forecast: forecast))
            })
            .store(in: &subscriptions)
    }

    private func getCurrentWeather() -> AnyPublisher<CurrentWeather, Error> {
        client.fetch(from: .currentWeather(coordinates: location),
                     expectedType: CurrentWeather.self)
    }

    // Get weather forecast from client, replacing erorrs with empty array and only selecting the forecase for noon each day
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

    // TODO: There is a known bug that will occur, you will be able to add a location more than once every time you restart the app. This can be resolved by first checking if it exists in CoreData before showing the bookmark button, this will not show multiple times in the list due to other handling but should be done to avoid polluting the CoreData database. If time permits, I will add the fix.

    func saveLocation() {
        var name = "Unknown"
        if case .loaded(let data) = weatherViewState,
           let model = data as? (current: CurrentWeather, forecast: [WeatherForecastItem]),
           let placeName = model.current.placeName {
            name = placeName
        }
        savedLocationService.add(location: location, name: name)
        showBookmarkButton = false
    }
}
