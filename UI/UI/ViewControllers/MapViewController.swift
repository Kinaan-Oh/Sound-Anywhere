//
//  MapViewController.swift
//  Time Capsule
//
//  Created by 오현식 on 2022/03/11.
//

import MapKit
import UIKit

import Common
import Presentation
import RxCocoa
import RxSwift

public final class MapViewController: UIViewController {
    
    // MARK: - Subviews
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var favoriteZoneButton: UIButton!
    @IBOutlet weak var currentLocationButton: UIButton!
    
    // MARK: - Private Properties
    
    public var viewModel: MapViewModelType? {
        didSet {
            if viewModel != nil {
                bindViewModel()
            }
        }
    }
    private var disposeBag = DisposeBag()
    private var currentLocationAnnotation = AnnotationFactory.create(of: .currentLocation,
                                                                     coordinate: .init())
    private var zoneAnnotations: [MKAnnotation] = []
    
    // MARK: - Lifecycle Methods
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configureMapView()
        configureUI()
        bindUI()
        bindNotifications()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel?.inputs.viewDidAppear()
    }
    
    // MARK: - Helpers
    
    private func configureMapView() {
        mapView.delegate = self
        mapView.register(ZoneAnnotationView.self,
                         forAnnotationViewWithReuseIdentifier: ZoneAnnotationView.identifier)
        mapView.register(CurrentLocationAnnotationView.self,
                         forAnnotationViewWithReuseIdentifier: CurrentLocationAnnotationView.identifier)
    }
    
    private func configureUI() {
        if let authorizationStatus = viewModel?.outputs.initialAuthorizationStatus,
           authorizationStatus == .authorizedWhenInUse {
            currentLocationButton.isEnabled = true
            setRecentRegion()
        } else {
            currentLocationButton.isEnabled = false
            setDefaultRegion()
        }
    }
    
    private func setDefaultRegion() {
        guard let defaultLocation = viewModel?.outputs.defaultLocation else { return }
        mapView.setRegion(location: defaultLocation)
    }
    
    private func setRecentRegion() {
        if let recentLocation = UserDefaultsService.recentLocation {
            mapView.setRegion(location: recentLocation)
            configureCurrentLocationAnnotation(location: recentLocation)
        }
    }
    
    private func configureCurrentLocationAnnotation(location: CLLocation) {
        mapView.removeAnnotation(currentLocationAnnotation)
        currentLocationAnnotation = AnnotationFactory.create(of: .currentLocation,
                                                             coordinate: location.coordinate)
        mapView.addAnnotation(currentLocationAnnotation)
    }
    
    private func configureZoneAnnotations(coordinates: [CLLocationCoordinate2D]) {
        mapView.removeAnnotations(zoneAnnotations)
        zoneAnnotations = coordinates.map { AnnotationFactory.create(of: .zone, coordinate: $0) }
        mapView.addAnnotations(zoneAnnotations)
    }
    
    private func bindViewModel() {
        viewModel?.outputs.authorizationStatus
            .drive { [weak self] authorizationStatus in
                guard let self = self else { return }
                switch authorizationStatus {
                case .authorizedWhenInUse:
                    self.currentLocationButton.isEnabled = true
                    self.setRecentRegion()
                default:
                    self.currentLocationButton.isEnabled = false
                    self.mapView.removeAnnotation(self.currentLocationAnnotation)
                }
            }
            .disposed(by: disposeBag)
        
        viewModel?.outputs.currentLocation
            .throttle(.seconds(1), latest: true)
            .drive { location in
                guard let location = location else { return }
                UserDefaultsService.recentLocation = location
            }
            .disposed(by: disposeBag)
        
        viewModel?.outputs.zoneCoordinates
            .drive { [weak self] zoneCoordinates in
                guard let self = self else { return }
                self.configureZoneAnnotations(coordinates: zoneCoordinates)
            }
            .disposed(by: disposeBag)
    }
    
    private func bindUI() {
        currentLocationButton.rx.tap
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.setRecentRegion()
            })
            .disposed(by: disposeBag)
    }
    
    private func bindNotifications() {
        NotificationCenter.default.rx
            .notification(UIScene.didActivateNotification)
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                self.viewModel?.inputs.sceneDidActivate()
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - MKMapViewDelegate

extension MapViewController: MKMapViewDelegate {
    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
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
