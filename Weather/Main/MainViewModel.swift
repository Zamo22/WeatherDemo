//
//  Created by Zaheer Moola on 2022/08/14.
//

import Foundation
import Combine

enum MainViewState {
    case loading
    case permissionDenied
    case locationError
    case loaded(coordinate: Coordinate)
}

class MainViewModel: ObservableObject {
    private let locationManager: Locatable
    private var subscriptions = Set<AnyCancellable>()

    @Published var viewState: MainViewState = .loading

    init(locationManager: Locatable = LocationManager()) {
        self.locationManager = locationManager
    }

    func getCurrentLocation() {
        listenForLocationPermissionFailure()
        locationManager.locationPublisher
            .receive(on: RunLoop.main)
            .first()
            .sink(receiveCompletion: { [weak self] in
                self?.handleSubscriptionFinished(with: $0)
            }, receiveValue: { [weak self] in
                self?.viewState = .loaded(coordinate: $0)
            })
            .store(in: &subscriptions)
    }

    private func listenForLocationPermissionFailure() {
        locationManager.authPublisher
            .receive(on: RunLoop.main)
            .first(where: { $0 == .denied || $0 == .restricted })
            .sink(receiveValue: { [weak self] _ in
                self?.viewState = .permissionDenied
            })
            .store(in: &subscriptions)
    }

    private func handleSubscriptionFinished(with completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            locationManager.disableLocationUpdates()
        case .failure:
            viewState = .locationError
        }
    }

    // TODO: Use core data here to get favourited locations
    // Consider returning a different model ? Whatever works best I guess
    func buildWeatherPages(with currentLocation: Coordinate) -> [Coordinate] {
        [currentLocation]
    }
}
