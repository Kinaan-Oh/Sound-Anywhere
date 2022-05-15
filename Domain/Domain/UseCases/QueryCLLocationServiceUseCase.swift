//
//  LocationManagerUseCase.swift
//  Domain
//
//  Created by 오현식 on 2022/04/19.
//

import CoreLocation

import RxCommon
import RxSwift

public protocol QueryCLLocationServiceUseCase {
    func observeAuthorizationStatus() -> Observable<CLAuthorizationStatus>
    func observeLocation() -> Observable<CLLocation?>
}

// MARK: - DefaultQueryCLLocationServiceUseCase

public final class DefaultQueryCLLocationServiceUseCase {
    private let locationService: CLLocationServiceQuerying
    
    public init(locationService: CLLocationServiceQuerying) {
        self.locationService = locationService
    }
}

extension DefaultQueryCLLocationServiceUseCase: QueryCLLocationServiceUseCase {
    public func observeAuthorizationStatus() -> Observable<CLAuthorizationStatus> {
        return locationService.observeAuthorizationStatus()
    }
    
    public func observeLocation() -> Observable<CLLocation?> {
        return locationService.observeLocation()
    }
}
