//
//  Created by Zaheer Moola on 2022/08/14.
//

import Foundation
import Combine

class MainViewModel: ObservableObject {
    private let locationManager: Locatable
    private let savedLocationsService: SavedLocationsProvider
    private var subscriptions = Set<AnyCancellable>()

    @Published var viewState: ViewState = .loading
    @Published var pages: [Coordinate] = []

    init(locationManager: Locatable = LocationManager(),
         savedLocationsService: SavedLocationsProvider = SavedLocationsService()) {
        self.locationManager = locationManager
        self.savedLocationsService = savedLocationsService
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
                self?.viewState = .loaded(data: $0)
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
                self?.viewState = .error(.locationPermission)
            })
            .store(in: &subscriptions)
    }

    private func handleSubscriptionFinished(with completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            locationManager.disableLocationUpdates()
        case .failure:
            viewState = .error(.generic)
        }
    }

    // Called externally to trigger a refresh of the view if necessary
    func refreshIfNeeded() {
        guard case .loaded(let data) = viewState,
                let coordinate = data as? Coordinate else {
            return
        }
        buildWeatherPages(with: coordinate)
    }

    // Sets up subscriber to listen to saved locations from Core Data service and call function to build weather pages accordingly
    func buildWeatherPages(with currentLocation: Coordinate) {
        pages = [currentLocation]
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
