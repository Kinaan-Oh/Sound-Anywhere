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
    var observeAuthorizationStatus_ReturnValue: Observable<CLAuthorizationStatus> = Observable.just(.notDetermined)
    var observeLocation_ReturnValue: Observable<CLLocation?> = Observable.just(nil)
    
    func observeAuthorizationStatus() -> Observable<CLAuthorizationStatus> {
        return observeAuthorizationStatus_ReturnValue
    }
    
    func observeLocation() -> Observable<CLLocation?> {
        return observeLocation_ReturnValue
    }
}
