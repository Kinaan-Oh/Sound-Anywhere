//
//  MapViewController.swift
//  Time Capsule
//
//  Created by 오현식 on 2022/03/11.
//

import MapKit
import UIKit

import Common
import Domain
import RxCocoa
import RxSwift

final class MapViewController: UIViewController {
    
    // MARK: - Subviews
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var favoriteZoneButton: UIButton!
    @IBOutlet weak var currentLocationButton: UIButton!
    
    // MARK: - Private Properties
    
    private let viewModel: MapViewModel = DIContainer.shared.resolve()
    private var disposeBag = DisposeBag()
    private var currentLocationAnnotation = AnnotationFactory.create(of: .currentLocation,
                                                                     coordinate: .init())
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMapView()
        configureLocation()
        bindViewModel()
        bindUI()
    }
    
    // MARK: - Helpers
    
    private func configureMapView() {
        mapView.delegate = self
        mapView.register(ZoneAnnotationView.self,
                         forAnnotationViewWithReuseIdentifier: ZoneAnnotationView.identifier)
        mapView.register(CurrentLocationAnnotationView.self,
                         forAnnotationViewWithReuseIdentifier: CurrentLocationAnnotationView.identifier)
    }
    
    private func configureCurrentLocationAnnotation(location: CLLocation) {
        mapView.removeAnnotation(currentLocationAnnotation)
        currentLocationAnnotation = AnnotationFactory.create(of: .currentLocation,
                                                             coordinate: location.coordinate)
        mapView.addAnnotation(currentLocationAnnotation)
    }
    
    private func configureZoneAnnotations(zone: [Zone]) {
        let annotations = zone.map { AnnotationFactory.create(of: .zone, coordinate: $0.coordinate)}
        mapView.addAnnotations(annotations)
    }
    
    private func configureLocation() {
        if let recentLocation = UserDefaultsService.recentLocation {
            mapView.setRegion(location: recentLocation)
            configureCurrentLocationAnnotation(location: recentLocation)
        } else {
            let defaultLocation = viewModel.getDefaultLocation()
            mapView.setRegion(location: defaultLocation)
        }
    }
    
    private func bindViewModel() {
        let viewDidAppearEvent = rx.viewDidAppear
            .mapToVoid()
            .asDriverOnErrorJustComplete()
        
        let sceneDidActivateNotificationEvent = NotificationCenter.default.rx
            .notification(UIScene.didActivateNotification)
            .mapToVoid()
            .asDriverOnErrorJustComplete()
        
        let input = MapViewModel.Input(viewDidAppearEvent: viewDidAppearEvent,
                                       sceneDidActivateNotificationEvent: sceneDidActivateNotificationEvent)
        let output = viewModel.transform(input: input)
        
        output.authorizationStatus
            .drive { [weak self] authorizationStatus in
                guard let self = self else { return }
                switch authorizationStatus {
                case .authorizedWhenInUse:
                    self.viewModel.startUpdatingLocation()
                    self.currentLocationButton.isEnabled = true
                    self.mapView.addAnnotation(self.currentLocationAnnotation)
                default:
                    self.viewModel.stopUpdatingLocation()
                    self.currentLocationButton.isEnabled = false
                    self.mapView.removeAnnotation(self.currentLocationAnnotation)
                }
            }
            .disposed(by: disposeBag)
        
        output.location
            .throttle(.seconds(1), latest: true)
            .drive { location in
                guard let location = location else { return }
                UserDefaultsService.recentLocation = location
            }
            .disposed(by: disposeBag)
        
        output.zone
            .drive { [weak self] zone in
                guard let self = self else { return }
                self.configureZoneAnnotations(zone: zone)
            }
            .disposed(by: disposeBag)
    }
    
    private func bindUI() {
        currentLocationButton.rx.tap
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.configureLocation()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - MKMapViewDelegate

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        switch annotation {
        case is CurrentLocationAnnotation:
            let identifier = CurrentLocationAnnotationView.identifier
            guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) else {
                return AnnotationViewFactory.create(of: .currentLocation,
                                                    annotation: annotation,
                                                    reuseIdentifier: identifier)
            }
            return annotationView
        case is ZoneAnnotation:
            let identifier = ZoneAnnotationView.identifier
            guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) else {
                return AnnotationViewFactory.create(of: .zone,
                                                    annotation: annotation,
                                                    reuseIdentifier: identifier)
            }
            return annotationView
        default:
            return nil
        }
    }
}
