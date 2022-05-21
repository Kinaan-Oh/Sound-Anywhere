//
//  CLLocationService.swift
//  Common
//
//  Created by 오현식 on 2022/05/04.
//

import CoreLocation

import RxSwift

// MARK: - CLLocationService

public final class CLLocationService: NSObject {
    private let locationManager = CLLocationManager()
    private var initialAuthorizationStatus: CLAuthorizationStatus? = nil
    
    public override init() {
        super.init()
        locationManager.delegate = self
    }
}

// MARK: - CLLocationManagerDelegate

extension CLLocationService: CLLocationManagerDelegate {
    
    @available(iOS 14.0, *)
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if initialAuthorizationStatus == nil {
            initialAuthorizationStatus = manager.authorizationStatus
        }
        
        switch manager.authorizationStatus {
        case .authorizedWhenInUse:
            manager.startUpdatingLocation()
        default:
            manager.stopUpdatingLocation()
        }
    }
    
    public func locationManager(
        _ manager: CLLocationManager,
        didChangeAuthorization status: CLAuthorizationStatus
    ) {
        if initialAuthorizationStatus == nil {
            initialAuthorizationStatus = status
        }
        
        switch status {
        case .authorizedWhenInUse:
            manager.startUpdatingLocation()
        default:
            manager.stopUpdatingLocation()
        }
    }
    
    public func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
    }
    
    public func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {
    }
}

// MARK: - CLLocationServiceCommanding

public protocol CLLocationServiceCommanding {
    func requestWhenInUseAuthorization()
    func startUpdatingLocation()
    func stopUpdatingLocation()
}

extension CLLocationService: CLLocationServiceCommanding {
    public func requestWhenInUseAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    public func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    public func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
}

// MARK: - CLLocationServiceQuerying

public protocol CLLocationServiceQuerying {
    func queryInitialAuthorizationStatus() -> CLAuthorizationStatus?
    func observeAuthorizationStatus() -> Observable<CLAuthorizationStatus>
    func observeLocation() -> Observable<CLLocation?>
}

extension CLLocationService: CLLocationServiceQuerying {
    public func queryInitialAuthorizationStatus() -> CLAuthorizationStatus? {
        return initialAuthorizationStatus
    }
    
    public func observeAuthorizationStatus() -> Observable<CLAuthorizationStatus> {
        return rx.authorizationStatus.asObservable()
    }
    
    public func observeLocation() -> Observable<CLLocation?> {
        return rx.location.asObservable()
    }
}

