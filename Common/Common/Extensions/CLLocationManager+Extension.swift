//
//  CLLocationManager+Extension.swift
//  Common
//
//  Created by 오현식 on 2022/04/23.
//

import CoreLocation

import RxCoreLocation
import RxSwift

public protocol CLLocationManagerCommanding {
    func requestWhenInUseAuthorization()
    func startUpdatingLocation()
    func stopUpdatingLocation()
}

public protocol CLLocationManagerQuerying {
    func observeAuthorizationStatus() -> Observable<CLAuthorizationStatus>
    func observeLocation() -> Observable<CLLocation?>
}

extension CLLocationManager: CLLocationManagerQuerying {
    public func observeAuthorizationStatus() -> Observable<CLAuthorizationStatus> {
        return rx
            .didChangeAuthorization
            .asObservable()
            .map { $0.status }
    }
    
    public func observeLocation() -> Observable<CLLocation?> {
        return rx
            .location
    }
}


