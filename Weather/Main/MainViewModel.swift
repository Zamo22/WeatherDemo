//
//  Created by Zaheer Moola on 2022/08/14.
//

import Foundation
import Combine

enum MainViewState {
    case loading
    case permissionDenied
    case error
    case loaded(coordinate: Coordinate)
}

class MainViewModel: ObservableObject {
    private let locationManager: Locatable
    private let savedLocationsService: SavedLocationsProvider
    private let userDefaults: UserDefaults
    private var subscriptions = Set<AnyCancellable>()

    @Published var viewState: MainViewState = .loading
    @Published var pages: [Coordinate] = []
    @Published var unitOfMeasurement: UnitMeasurement

    init(locationManager: Locatable = LocationManager(),
         userDefaults: UserDefaults = UserDefaults.standard,
         savedLocationsService: SavedLocationsProvider = SavedLocationsService()) {
        self.locationManager = locationManager
        self.savedLocationsService = savedLocationsService
        self.userDefaults = userDefaults
        self.unitOfMeasurement = userDefaults.unitOfMeasurement
    }

    // Subscribes to location changes but only picks the first location then stops listening
    func getCurrentLocation() {
        listenForLocationPermissionFailure()
        locationManager.locationPublisher
            .receive(on: RunLoop.main)
            .first()
            .sink(receiveCompletion: { [weak self] in
                self?.handleSubscriptionFinished(with: $0)
            }, receiveValue: { [weak self] in
                self?.viewState = .loaded(coordinate: $0)
                self?.buildWeatherPages(with: $0)
            })
            .store(in: &subscriptions)
    }

    //Sets up subscriber to listen for failures related to location permission and update the view if necessary
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
            viewState = .error
        }
    }

    // Called externally to trigger a refresh of the view if necessary
    func refreshIfNeeded() {
        guard case .loaded(let coordinate) = viewState else {
            return
        }
        buildWeatherPages(with: coordinate)
        let newMeasure = userDefaults.unitOfMeasurement
        unitOfMeasurement = newMeasure
    }

    // Sets up subscriber to listen to saved locations from Core Data service and call function to build weather pages accordingly
    func buildWeatherPages(with currentLocation: Coordinate) {
        savedLocationsService.savedLocationPublisher
            .receive(on: RunLoop.main)
            .replaceError(with: [])
            .sink(receiveValue: { [weak self] in
                self?.buildWeatherPages(usingCurrentLocation: currentLocation, andSaved: $0)
            })
            .store(in: &subscriptions)

        savedLocationsService.getSavedLocations()
    }

    private func buildWeatherPages(usingCurrentLocation current: Coordinate, andSaved saved: [SavedLocation]) {
        var savedPages = saved.map { Coordinate(latitude: $0.latitude, longitude: $0.longitude) }
        savedPages.insert(current, at: 0)
        pages = savedPages.uniqued()
    }
}
