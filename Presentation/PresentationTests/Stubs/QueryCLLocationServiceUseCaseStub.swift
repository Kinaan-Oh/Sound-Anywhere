//
//  LocationManagerUseCaseStub.swift
//  PresentationTests
//
//  Created by 오현식 on 2022/04/22.
//

import CoreLocation

import Domain
import RxSwift

final class QueryCLLocationServiceUseCaseStub: QueryCLLocationServiceUseCase {
    var initialAuthorizationStatus_ReturnValue: CLAuthorizationStatus = .notDetermined
    var observeAuthorizationStatus_ReturnValue: Observable<CLAuthorizationStatus> = Observable.just(.notDetermined)
    var observeLocation_ReturnValue: Observable<CLLocation?> = Observable.just(nil)
    
    func queryInitialAuthorizationStatus() -> CLAuthorizationStatus? {
        return initialAuthorizationStatus_ReturnValue
    }
    
    func observeAuthorizationStatus() -> Observable<CLAuthorizationStatus> {
        return observeAuthorizationStatus_ReturnValue
    }
    
    func observeLocation() -> Observable<CLLocation?> {
        return observeLocation_ReturnValue
    }
}

