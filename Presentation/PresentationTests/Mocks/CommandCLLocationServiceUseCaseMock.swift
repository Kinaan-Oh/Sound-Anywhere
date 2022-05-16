//
//  LocationManagerUseCaseMock.swift
//  PresentationTests
//
//  Created by 오현식 on 2022/04/20.
//

import CoreLocation

import Domain
import RxSwift

final class CommandCLLocationServiceUseCaseMock: CommandCLLocationServiceUseCase {
    var requestWhenInUseAuthorization_Called_Count = 0
    var startUpdatingLocation_Called = false
    var stopUpdatingLocation_Called = false
    
    func requestWhenInUseAuthorization() {
        requestWhenInUseAuthorization_Called_Count += 1
    }
    
    func startUpdatingLocation() {
        startUpdatingLocation_Called = true
    }
    
    func stopUpdatingLocation() {
        stopUpdatingLocation_Called = true
    }
}
