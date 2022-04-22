//
//  CommandLocationManagerUseCase.swift
//  Domain
//
//  Created by 오현식 on 2022/04/22.
//

import CoreLocation

public protocol CommandLocationManagerUseCase {
    func requestWhenInUseAuthorization()
    func startUpdatingLocation()
    func stopUpdatingLocation()
}

public final class DefaultCommandLocationManagerUseCase: NSObject, CommandLocationManagerUseCase {
    private let locationManager: CLLocationManager
    
    public init(locationManager: CLLocationManager) {
        self.locationManager = locationManager
        super.init()
    }

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
