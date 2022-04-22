//
//  LocationManagerUseCase.swift
//  Domain
//
//  Created by 오현식 on 2022/04/19.
//

import CoreLocation

import Common
import RxCoreLocation
import RxSwift

public protocol QueryLocationManagerUseCase {
    func observeAuthorizationStatus() -> Observable<CLAuthorizationStatus>
    func observeLocation() -> Observable<CLLocation?>
}

public final class DefaultQueryLocationManagerUseCase: NSObject, QueryLocationManagerUseCase {
    private let locationManager: CLLocationManagerQuerying
    
    public init(locationManager: CLLocationManagerQuerying) {
        self.locationManager = locationManager
        super.init()
        (locationManager as? CLLocationManager)?.delegate = self
    }
    
    public func observeAuthorizationStatus() -> Observable<CLAuthorizationStatus> {
        return locationManager.observeAuthorizationStatus()
    }
    
    public func observeLocation() -> Observable<CLLocation?> {
        return locationManager.observeLocation()
    }
}

// MARK: - CLLocationManagerDelegate

extension DefaultQueryLocationManagerUseCase: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    }
}
