//
//  CLLocationCoordinate2D+Extension.swift
//  Common
//
//  Created by 오현식 on 2022/04/24.
//

import CoreLocation

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return
            lhs.latitude == rhs.latitude &&
            lhs.longitude == rhs.longitude
    }
}
