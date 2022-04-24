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

protocol MapViewModelQuerying {
    func getDefaultLocation() -> CLLocation
}

protocol MapViewModelCommanding {
    func startUpdatingLocation()
    func stopUpdatingLocation()
}

public final class MapViewModel: ViewModelType {
    public struct Input {
        let viewDidAppearEvent: Driver<Bool>
    }
    
    public struct Output {
        let authorizationStatus: Driver<CLAuthorizationStatus>
        let location: Driver<CLLocation?>
    }
    
    public struct Dependencies {
        var defaultLocation: CLLocation
        var queryLocationManagerUseCase: QueryLocationManagerUseCase
        var commandLocationManagerUseCase: CommandLocationManagerUseCase
        var queryZoneUseCase: QueryZoneUseCase
        
        public init(defaultLocation: CLLocation,
                    queryLocationManagerUseCase: QueryLocationManagerUseCase,
                    commandLocationManagerUseCase: CommandLocationManagerUseCase,
                    queryZoneUseCase: QueryZoneUseCase
        ) {
            self.defaultLocation = defaultLocation
            self.queryLocationManagerUseCase = queryLocationManagerUseCase
            self.commandLocationManagerUseCase = commandLocationManagerUseCase
            self.queryZoneUseCase = queryZoneUseCase
        }
    }
    
    public let dependencies: Dependencies
    public var disposeBag = DisposeBag()
    
    public init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    public func transform(input: Input) -> Output {
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
