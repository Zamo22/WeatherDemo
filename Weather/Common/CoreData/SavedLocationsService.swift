//
//  Created by Zaheer Moola on 2022/08/15.
//

import Foundation
import CoreData
import Combine

protocol SavedLocationsProvider {
    var savedLocationPublisher: AnyPublisher<[SavedLocation], Error> { get }
    func getSavedLocations()
    func add(location: Coordinate, name: String)
    func remove(location: SavedLocation)
}

class SavedLocationsService: SavedLocationsProvider {
    let container = PersistenceController.shared.container

    private let internalSavedLocationPublisher = PassthroughSubject<[SavedLocation], Error>()
    var savedLocationPublisher: AnyPublisher<[SavedLocation], Error>

    init() {
        savedLocationPublisher = internalSavedLocationPublisher.eraseToAnyPublisher()
    }

    func getSavedLocations() {
        let request = NSFetchRequest<SavedLocation>(entityName: Constants.Storage.savedLocationEntityName)
        do {
            let savedEntities = try container.viewContext.fetch(request)
            internalSavedLocationPublisher.send(savedEntities)
        } catch {
            internalSavedLocationPublisher.send(completion: .failure(error))
        }
    }

    func add(location: Coordinate, name: String) {
        let newLocation = SavedLocation(context: container.viewContext)
        newLocation.name = name
        newLocation.latitude = location.latitude
        newLocation.longitude = location.longitude
        applyChanges()
    }

    func remove(location: SavedLocation) {
        container.viewContext.delete(location)
        applyChanges()
    }

    private func applyChanges() {
        do {
            try container.viewContext.save()
        } catch {
            internalSavedLocationPublisher.send(completion: .failure(error))
        }
        getSavedLocations()
    }
}
