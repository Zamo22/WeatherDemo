//
//  Created by Zaheer Moola on 2022/08/13.
//

import Foundation
import Combine
import CoreLocation

protocol Locatable {
    var locationPublisher: AnyPublisher<Coordinate, Error> { get }
    var authPublisher: AnyPublisher<CLAuthorizationStatus, Never> { get }
    func disableLocationUpdates()
}

class LocationManager: NSObject, CLLocationManagerDelegate, Locatable {
    private let locationManager = CLLocationManager()

    private let internalLocationPublisher = PassthroughSubject<Coordinate, Error>()
    var locationPublisher: AnyPublisher<Coordinate, Error>

    private let internalAuthPublisher = PassthroughSubject<CLAuthorizationStatus, Never>()
    var authPublisher: AnyPublisher<CLAuthorizationStatus, Never>

    override init() {
        locationPublisher = internalLocationPublisher.eraseToAnyPublisher()
        authPublisher = internalAuthPublisher.eraseToAnyPublisher()
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func disableLocationUpdates() {
        locationManager.stopUpdatingLocation()
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        internalAuthPublisher.send(manager.authorizationStatus)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let coordinate = Coordinate(latitude: location.coordinate.latitude,
                                    longitude: location.coordinate.longitude)
        internalLocationPublisher.send(coordinate)
    }
}
