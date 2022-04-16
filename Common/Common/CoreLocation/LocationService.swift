//
//  LocationService.swift
//  Common
//
//  Created by 오현식 on 2022/04/16.
//

import CoreLocation

import RxCoreLocation
import RxSwift

final class LocationService: NSObject {
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.distanceFilter = CLLocationDistance(3)
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func observeAuthorizationStatus() -> Observable<CLAuthorizationStatus> {
        return locationManager.rx
            .didChangeAuthorization
            .asObservable()
            .map { $0.status }
    }
    
    func observeLocation() -> Observable<CLLocation?> {
        return locationManager.rx
            .location
    }
    
    func requestWhenInUseAuthorization() {
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    func requestLocation() {
        locationManager.requestLocation()
    }
}


// MARK: - CLLocationManagerDelegate

extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    }
}

