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
    
    private lazy var viewModel: MapViewModel = {
        let locationManager = CLLocationManager()
        locationManager.distanceFilter = CLLocationDistance(3)
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        let viewModel = MapViewModel(
            dependencies: .init(
                defaultLocation: CLLocation(latitude: 37.54330366639085,
                                            longitude: 127.04455548501139),
                queryLocationManagerUseCase: DefaultQueryLocationManagerUseCase(locationManager: locationManager) ,
                commandLocationManagerUseCase: DefaultCommandLocationManagerUseCase(locationManager: locationManager)
            )
        )
        return viewModel
    }()
    
    private var disposeBag = DisposeBag()
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLocation()
        bindViewModel()
    }
    
    // MARK: - Helpers
    
    private func configureLocation() {
        if let recentLocation = UserDefaultsService.recentLocation {
            mapView.setRegion(location: recentLocation)
        } else {
            let defaultLocation = viewModel.getDefaultLocation()
            mapView.setRegion(location: defaultLocation)
        }
    }
    
    private func bindViewModel() {
        let viewDidAppearEvent = self.rx.viewDidAppear
            .asDriver()
        
        let input = MapViewModel.Input(viewDidAppearEvent: viewDidAppearEvent)
        let output = viewModel.transform(input: input)
        
        output.authorizationStatus
            .drive { [weak self] authorizationStatus in
                guard let self = self,
                      authorizationStatus == .authorizedWhenInUse
                else { return }
                self.viewModel.startUpdatingLocation()
            }
            .disposed(by: disposeBag)
        
        output.location
            .drive { [weak self] location in
                guard let self = self,
                      let location = location
                else { return }
                UserDefaultsService.recentLocation = location
            }
            .disposed(by: disposeBag)
    }
    
    private func bindUI() {
    }
}
