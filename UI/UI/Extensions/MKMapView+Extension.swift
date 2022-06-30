//
//  MKMapView+Extension.swift
//  Presentation
//
//  Created by 오현식 on 2022/04/22.
//

import MapKit

extension MKMapView {
    func setRegion(location: CLLocation) {
        let region = MKCoordinateRegion(center: location.coordinate,
                                        span: MKCoordinateSpan(latitudeDelta: 0.01,
                                                               longitudeDelta: 0.01))
        self.setRegion(region, animated: true)
    }
}
