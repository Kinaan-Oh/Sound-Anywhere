//
//  LocationManagerUseCaseMock.swift
//  PresentationTests
//
//  Created by 오현식 on 2022/04/20.
//

import CoreLocation

import Domain
import RxSwift

final class LocationManagerUseCaseMock: LocationManagerUseCase {
    var observeAuthorizationStatus_Called = false
    var observeLocation_Called = false
    var requestWhenInUseAuthorization_Called = false
    var startUpdatingLocation_Called = false
    var stopUpdatingLocation_Called = false
    
    func observeAuthorizationStatus() -> Observable<CLAuthorizationStatus> {
        observeAuthorizationStatus_Called = true
        return Observable.just(.notDetermined)
    }
    
    func observeLocation() -> Observable<CLLocation?> {
        observeLocation_Called = true
        return Observable.just(nil)
    }
    
    func requestWhenInUseAuthorization() {
        requestWhenInUseAuthorization_Called = true
    }
    
    func startUpdatingLocation() {
        startUpdatingLocation_Called = true
    }
    
    func stopUpdatingLocation() {
        stopUpdatingLocation_Called = true
    }
}
