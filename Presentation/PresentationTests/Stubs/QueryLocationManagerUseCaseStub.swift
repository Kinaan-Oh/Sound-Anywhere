//
//  LocationManagerUseCaseStub.swift
//  PresentationTests
//
//  Created by 오현식 on 2022/04/22.
//

import CoreLocation

import Domain
import RxSwift

final class QueryLocationManagerUseCaseStub: QueryLocationManagerUseCase {
    func observeAuthorizationStatus() -> Observable<CLAuthorizationStatus> {
        return Observable.just(.notDetermined)
    }
    
    func observeLocation() -> Observable<CLLocation?> {
        return Observable.just(nil)
    }
}

