//
//  CLLocationService+Rx.swift
//  Common
//
//  Created by 오현식 on 2022/05/04.
//

import CoreLocation

import RxCocoa
import RxSwift

extension Reactive where Base: CLLocationService {
    var authorizationStatus: ControlEvent<CLAuthorizationStatus> {
        var source: Observable<CLAuthorizationStatus>
        
        if #available(iOS 14.0, *) {
            source = self.methodInvoked(#selector(Base.locationManagerDidChangeAuthorization(_:)))
                .map { ($0.first as? CLLocationManager)?.authorizationStatus ?? CLAuthorizationStatus.notDetermined }
        } else {
            source = self.methodInvoked(#selector(Base.locationManager(_:didChangeAuthorization:)))
                .map { $0[1] as? CLAuthorizationStatus ?? CLAuthorizationStatus.notDetermined }
        }
        return ControlEvent(events: source)
    }
    
    var location: ControlEvent<CLLocation?> {
        let source = self.methodInvoked(#selector(Base.locationManager(_:didUpdateLocations:)))
            .map { ($0[1] as? [CLLocation])?.last ?? nil }
        return ControlEvent(events: source)
    }
}
