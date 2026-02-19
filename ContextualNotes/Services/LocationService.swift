import Foundation
import CoreLocation

/// Core Location, geofencing, and reverse geocoding
@Observable
final class LocationService: NSObject, LocationServiceProtocol {
    private let manager = CLLocationManager()
    private var locationContinuation: CheckedContinuation<CLLocation?, Never>?

    var authorizationStatus: CLAuthorizationStatus { manager.authorizationStatus }
    var isAuthorized: Bool {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse: return true
        default: return false
        }
    }

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func requestWhenInUseAuthorization() {
        manager.requestWhenInUseAuthorization()
    }

    func requestAlwaysAuthorization() {
        manager.requestAlwaysAuthorization()
    }

    func startUpdatingLocation() {
        manager.startUpdatingLocation()
    }

    func stopUpdatingLocation() {
        manager.stopUpdatingLocation()
    }

    var currentLocation: CLLocation? {
        manager.location
    }

    func currentLocationAsync() async -> CLLocation? {
        if let loc = manager.location { return loc }
        return await withCheckedContinuation { continuation in
            locationContinuation = continuation
            manager.requestLocation()
        }
    }

    func reverseGeocode(latitude: Double, longitude: Double) async -> String? {
        let loc = CLLocation(latitude: latitude, longitude: longitude)
        let geocoder = CLGeocoder()
        do {
            let placemarks = try await geocoder.reverseGeocodeLocation(loc)
            return placemarks.first?.name ?? placemarks.first?.locality
        } catch {
            return nil
        }
    }
}

extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationContinuation?.resume(returning: locations.last)
        locationContinuation = nil
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationContinuation?.resume(returning: nil)
        locationContinuation = nil
    }
}

// MARK: - Protocol for dependency injection / testing
protocol LocationServiceProtocol: AnyObject {
    var currentLocation: CLLocation? { get }
    func currentLocationAsync() async -> CLLocation?
    func reverseGeocode(latitude: Double, longitude: Double) async -> String?
}
