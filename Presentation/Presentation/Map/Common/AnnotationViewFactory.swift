//
//  AnnotationViewFactory.swift
//  Presentation
//
//  Created by 오현식 on 2022/04/25.
//

// Reference : https://github.com/ochococo/Design-Patterns-In-Swift#-factory-method

import MapKit

import Resource

enum AnnotationViewFactory {
    enum AnnotationViewType {
        case currentLocation
        case zone
    }
    
    static func create(of type: AnnotationViewType,
                       annotation: MKAnnotation?,
                       reuseIdentifier: String?
    ) -> MKAnnotationView {
        switch type {
        case .zone:
            return ZoneAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
        case .currentLocation:
            return CurrentLocationAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
        }
    }
}


// MARK: - ZoneAnnotationView

final class ZoneAnnotationView: MKAnnotationView {
    static let identifier = String(describing: ZoneAnnotationView.self)
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        
        displayPriority = .defaultHigh
        image = Resource.Image.zoneShadow
        frame.size = CGSize(width: 36, height: 48)
    }
}

// MARK: - CurrentLocationAnnotationView

final class CurrentLocationAnnotationView: MKAnnotationView {
    static let identifier = String(describing: CurrentLocationAnnotationView.self)
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        
        displayPriority = .required
        image = Resource.Image.currentLoc
        frame.size = CGSize(width: 32, height: 32)
    }
}
