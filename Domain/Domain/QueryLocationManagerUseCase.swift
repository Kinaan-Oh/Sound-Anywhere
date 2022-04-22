//
//  LocationManagerUseCase.swift
//  Domain
//
//  Created by 오현식 on 2022/04/19.
//

import CoreLocation

import RxCoreLocation
import RxSwift

public protocol QueryLocationManagerUseCase {
    func observeAuthorizationStatus() -> Observable<CLAuthorizationStatus>
    func observeLocation() -> Observable<CLLocation?>
}

public final class DefaultQueryLocationManagerUseCase: NSObject, QueryLocationManagerUseCase {
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
}

// MARK: - CLLocationManagerDelegate

extension DefaultQueryLocationManagerUseCase: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    }
}
