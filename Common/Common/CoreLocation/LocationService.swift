//
//  LocationService.swift
//  Common
//
//  Created by 오현식 on 2022/04/16.
//

import CoreLocation

import RxCoreLocation
import RxSwift

final public class LocationService: NSObject {
    private let locationManager = CLLocationManager()
    
    public override init() {
        super.init()
        locationManager.delegate = self
        locationManager.distanceFilter = CLLocationDistance(3)
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    public func observeAuthorizationStatus() -> Observable<CLAuthorizationStatus> {
        return locationManager.rx
            .didChangeAuthorization
            .asObservable()
            .map { $0.status }
    }
    
    public func observeLocation() -> Observable<CLLocation?> {
        return locationManager.rx
            .location
    }
    
    public func requestWhenInUseAuthorization() {
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    public func requestLocation() {
        locationManager.requestLocation()
    }
}


// MARK: - CLLocationManagerDelegate

extension LocationService: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    }
}

