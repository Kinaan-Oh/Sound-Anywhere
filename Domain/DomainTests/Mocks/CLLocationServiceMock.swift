//
//  CLLocationManagerMock.swift
//  DomainTests
//
//  Created by 오현식 on 2022/04/23.
//

import Common

final class CLLocationServiceMock: CLLocationServiceCommanding {
    var requestWhenInUseAuthorization_Called = false
    var startUpdatingLocation_Called = false
    var stopUpdatingLocation_Called = false
    
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
