//
//  AnnotationFactory.swift
//  Presentation
//
//  Created by 오현식 on 2022/04/25.
//

// Reference : https://github.com/ochococo/Design-Patterns-In-Swift#-factory-method

import CoreLocation
import MapKit

import Domain

enum AnnotationFactory {
    enum AnnotationType {
        case currentLocation
        case zone
    }
    
    static func create(of type: AnnotationType,
                        coordinate: CLLocationCoordinate2D
    ) -> MKAnnotation {
        switch type {
        case .zone:
            return ZoneAnnotation(coordinate)
        case .currentLocation:
            return CurrentLocationAnnotation(coordinate)
        }
    }
}

// MARK: - ZoneAnnotation

final class ZoneAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    
    init(_ coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}

// MARK: - CurrentLocationAnnotation

final class CurrentLocationAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    
    init(_ coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}
