//
//  CommandLocationManagerUseCase.swift
//  Domain
//
//  Created by 오현식 on 2022/04/22.
//

import CoreLocation

import Common

public protocol CommandCLLocationServiceUseCase {
    func requestWhenInUseAuthorization()
    func startUpdatingLocation()
    func stopUpdatingLocation()
}

// MARK: - DefaultCommandCLLocationServiceUseCase

public final class DefaultCommandCLLocationServiceUseCase {
    private let locationService: CLLocationServiceCommanding
    
    public init(locationService: CLLocationServiceCommanding) {
        self.locationService = locationService
    }
}

extension DefaultCommandCLLocationServiceUseCase: CommandCLLocationServiceUseCase {
    public func requestWhenInUseAuthorization() {
        locationService.requestWhenInUseAuthorization()
    }
    
    public func startUpdatingLocation() {
        locationService.startUpdatingLocation()
    }
    
    public func stopUpdatingLocation() {
        locationService.stopUpdatingLocation()
    }
}
