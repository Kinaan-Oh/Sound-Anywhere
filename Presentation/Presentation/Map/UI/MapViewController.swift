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
    
    private lazy var viewModel: MapViewModel = DIContainer.shared.resolve()
    private var disposeBag = DisposeBag()
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLocation()
        bindViewModel()
        bindUI()
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
        let viewDidAppearEvent = rx.viewDidAppear.asDriver()
        
        let input = MapViewModel.Input(viewDidAppearEvent: viewDidAppearEvent)
        let output = viewModel.transform(input: input)
        
        output.authorizationStatus
            .drive { [weak self] authorizationStatus in
                guard let self = self else { return }
                switch authorizationStatus {
                case .authorizedWhenInUse:
                    self.viewModel.startUpdatingLocation()
                default:
                    self.viewModel.stopUpdatingLocation()
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
