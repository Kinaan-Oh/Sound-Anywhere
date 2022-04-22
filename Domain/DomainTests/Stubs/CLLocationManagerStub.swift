//
//  CLLocationManagerStub.swift
//  DomainTests
//
//  Created by 오현식 on 2022/04/23.
//

import CoreLocation

import Common
import RxSwift

final class CLLocationManagerStub: CLLocationManagerQuerying {
    func observeAuthorizationStatus() -> Observable<CLAuthorizationStatus> {
        return Observable.just(.notDetermined)
    }
    
    func observeLocation() -> Observable<CLLocation?> {
        return Observable.just(nil)
    }
}
