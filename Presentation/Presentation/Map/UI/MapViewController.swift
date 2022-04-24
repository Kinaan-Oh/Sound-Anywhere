//
//  MapViewController.swift
//  Time Capsule
//
//  Created by 오현식 on 2022/03/11.
//

import MapKit
import UIKit

import Common
import DIContainer
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
