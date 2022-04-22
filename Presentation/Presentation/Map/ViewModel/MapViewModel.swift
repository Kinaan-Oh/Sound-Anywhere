//
//  MapViewModel.swift
//  Time Capsule
//
//  Created by 오현식 on 2022/03/11.
//

// Reference: https://github.com/sergdort/CleanArchitectureRxSwift

import CoreLocation

import Domain
import RxCocoa
import RxSwift

final class MapViewModel: ViewModelType {
    struct Input {
        let viewDidAppearEvent: Driver<Bool>
    }
    
    struct Output {
        let authorizationStatus: Driver<CLAuthorizationStatus>
        let location: Driver<CLLocation?>
    }
    
    struct Dependencies {
        let defaultLocation: CLLocation
        let queryLocationManagerUseCase: QueryLocationManagerUseCase
        let commandLocationManagerUseCase: CommandLocationManagerUseCase
    }
    
    let dependencies: Dependencies
    var disposeBag = DisposeBag()
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func transform(input: Input) -> Output {
        input.viewDidAppearEvent
            .drive { [weak self] _ in
                self?.dependencies.commandLocationManagerUseCase.requestWhenInUseAuthorization()
            }
            .disposed(by: disposeBag)
        
        let authorizationStatus = dependencies.queryLocationManagerUseCase
            .observeAuthorizationStatus()
            .asDriverOnErrorJustComplete()
        
        let location = dependencies.queryLocationManagerUseCase
            .observeLocation()
            .asDriverOnErrorJustComplete()
        
        return Output(authorizationStatus: authorizationStatus,
                      location: location)
    }
}


// MARK: - MapViewModelCommanding

extension MapViewModel: MapViewModelCommanding {
    func startUpdatingLocation() {
        dependencies.commandLocationManagerUseCase.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        dependencies.commandLocationManagerUseCase.stopUpdatingLocation()
    }
}


// MARK: - MapViewModelQuerying

extension MapViewModel: MapViewModelQuerying {
    func getDefaultLocation() -> CLLocation {
        return dependencies.defaultLocation
    }
}
