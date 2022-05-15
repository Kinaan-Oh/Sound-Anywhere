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
    
    public override init() {
        super.init()
        locationManager.delegate = self
    }
}

// MARK: - CLLocationManagerDelegate

extension CLLocationService: CLLocationManagerDelegate {
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    }
    
    public func locationManager(
        _ manager: CLLocationManager,
        didChangeAuthorization status: CLAuthorizationStatus
    ) {
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
    func observeAuthorizationStatus() -> Observable<CLAuthorizationStatus>
    func observeLocation() -> Observable<CLLocation?>
}

extension CLLocationService: CLLocationServiceQuerying {
    public func observeAuthorizationStatus() -> Observable<CLAuthorizationStatus> {
        return rx.authorizationStatus.asObservable()
    }
    
    public func observeLocation() -> Observable<CLLocation?> {
        return rx.location.asObservable()
    }
}

