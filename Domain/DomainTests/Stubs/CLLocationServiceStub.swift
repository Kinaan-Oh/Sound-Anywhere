//
//  CLLocationManagerStub.swift
//  DomainTests
//
//  Created by 오현식 on 2022/04/23.
//

import CoreLocation

import Common
import RxSwift

final class CLLocationServiceStub: CLLocationServiceQuerying {
    private let observeAuthorizationStatus_ReturnValue: Observable<CLAuthorizationStatus>
    private let  observeLocation_ReturnValue: Observable<CLLocation?>
    
    init() {
        observeAuthorizationStatus_ReturnValue = Observable.just(.notDetermined)
        observeLocation_ReturnValue = Observable<CLLocation?>.just(nil)
    }
    
    func observeAuthorizationStatus() -> Observable<CLAuthorizationStatus> {
        return observeAuthorizationStatus_ReturnValue
    }
    
    func observeLocation() -> Observable<CLLocation?> {
        return observeLocation_ReturnValue
    }
}
