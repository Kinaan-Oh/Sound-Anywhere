//
//  MapViewModelCommanding.swift
//  Presentation
//
//  Created by 오현식 on 2022/04/22.
//

import CoreLocation

protocol MapViewModelCommandable {
    func getDefaultLocation() -> CLLocation
    func startUpdatingLocation()
    func stopUpdatingLocation()
}
