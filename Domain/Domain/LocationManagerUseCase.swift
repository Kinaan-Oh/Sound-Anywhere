//
//  LocationManagerUseCase.swift
//  Domain
//
//  Created by 오현식 on 2022/04/19.
//

import CoreLocation

import RxCoreLocation
import RxSwift

public protocol LocationManagerUseCase {
    func observeAuthorizationStatus() -> Observable<CLAuthorizationStatus>
    func observeLocation() -> Observable<CLLocation?>
    func requestWhenInUseAuthorization()
    func requestLocation()
}

public final class DefaultLocationManagerUseCase: NSObject, LocationManagerUseCase {
    private let locationManager: CLLocationManager
    
    public init(locationManager: CLLocationManager) {
        self.locationManager = locationManager
        super.init()
        locationManager.delegate = self
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
        locationManager.requestWhenInUseAuthorization()
    }
    
    public func requestLocation() {
        locationManager.requestLocation()
    }
}

// MARK: - CLLocationManagerDelegate

extension DefaultLocationManagerUseCase: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    }
}
