//
//  CLLocation+Extension.swift
//  Common
//
//  Created by 오현식 on 2022/04/19.
//

import CoreLocation
import MapKit

extension CLLocation {
    public func toCLLocationCoordinate2D() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.coordinate.latitude,
                                      longitude: self.coordinate.longitude)
    }
    
    public func toMKCoordinateRegion() -> MKCoordinateRegion {
        return MKCoordinateRegion(center: self.toCLLocationCoordinate2D(),
                                  span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
    }
}
