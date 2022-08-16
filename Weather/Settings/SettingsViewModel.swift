//
//  Created by Zaheer Moola on 2022/08/15.
//

import Foundation
import Combine

class SettingsViewModel: ObservableObject {
    let defaults: UserDefaults
    let savedLocationsService: SavedLocationsProvider
    @Published var unitOfMeasurement: UnitMeasurement
    @Published var savedLocations: [SavedLocation] = []


    private var subscriptions = Set<AnyCancellable>()

    init(userDefaults: UserDefaults = UserDefaults.standard,
         savedLocationsService service: SavedLocationsProvider = SavedLocationsService()) {
        self.defaults = userDefaults
        self.savedLocationsService = service
        self.unitOfMeasurement = userDefaults.unitOfMeasurement
        handleUnitOfMeasurementUpdates()
        handleSavedLocationsUpdates()
    }

    // Sets up subscriber to update user defaults when the picker is changed, first is ignored to ignore the event published on initial setting of the value
    private func handleUnitOfMeasurementUpdates() {
        $unitOfMeasurement
            .dropFirst()
            .sink(receiveValue: {
            self.defaults.unitOfMeasurement = $0
        })
        .store(in: &subscriptions)
    }

    private func handleSavedLocationsUpdates() {
        savedLocationsService.savedLocationPublisher
            .receive(on: RunLoop.main)
            .replaceError(with: [])
            .assign(to: \.savedLocations, on: self)
            .store(in: &subscriptions)
        savedLocationsService.getSavedLocations()
    }

    func removeSavedLocation(_ location: SavedLocation) {
        savedLocationsService.remove(location: location)
    }
}
