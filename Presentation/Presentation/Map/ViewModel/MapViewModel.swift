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
        let viewDidAppearEvent: Driver<Void>
        let sceneDidActivateNotificationEvent: Driver<Void>
    }
    
    public struct Output {
        let authorizationStatus: Driver<CLAuthorizationStatus>
        let location: Driver<CLLocation?>
        let zone: Driver<[Zone]>
    }
    
    public struct Dependencies {
        var defaultLocation: CLLocation
        var queryCLLocationServiceUseCase: QueryCLLocationServiceUseCase
        var commandCLLocationServiceUseCase: CommandCLLocationServiceUseCase
        var queryZoneUseCase: QueryZoneUseCase
        
        public init(defaultLocation: CLLocation,
                    queryCLLocationServiceUseCase: QueryCLLocationServiceUseCase,
                    commandCLLocationServiceUseCase: CommandCLLocationServiceUseCase,
                    queryZoneUseCase: QueryZoneUseCase
        ) {
            self.defaultLocation = defaultLocation
            self.queryCLLocationServiceUseCase = queryCLLocationServiceUseCase
            self.commandCLLocationServiceUseCase = commandCLLocationServiceUseCase
            self.queryZoneUseCase = queryZoneUseCase
        }
    }
    
    public let dependencies: Dependencies
    public var disposeBag = DisposeBag()
    
    public init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    public func transform(input: Input) -> Output {
        Driver.merge(input.viewDidAppearEvent, input.sceneDidActivateNotificationEvent)
            .drive { [weak self] _ in
                guard let self = self else { return }
                self.dependencies.commandCLLocationServiceUseCase.requestWhenInUseAuthorization()
            }
            .disposed(by: disposeBag)
        
        let zone: Driver<[Zone]> = input.viewDidAppearEvent
            .flatMapLatest { [weak self] _ in
                guard let self = self else { return Driver<[Zone]>.just([]) }
                return self.dependencies.queryZoneUseCase.query()
                    .asDriverOnErrorJustComplete()
            }
        
        let authorizationStatus = dependencies.queryCLLocationServiceUseCase
            .observeAuthorizationStatus()
            .asDriverOnErrorJustComplete()
        
        let location = dependencies.queryCLLocationServiceUseCase
            .observeLocation()
            .asDriverOnErrorJustComplete()
        
        return Output(authorizationStatus: authorizationStatus,
                      location: location,
                      zone: zone)
    }
}


// MARK: - MapViewModelCommanding

extension MapViewModel: MapViewModelCommanding {
    func startUpdatingLocation() {
        dependencies.commandCLLocationServiceUseCase.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        dependencies.commandCLLocationServiceUseCase.stopUpdatingLocation()
    }
}


// MARK: - MapViewModelQuerying

extension MapViewModel: MapViewModelQuerying {
    func getDefaultLocation() -> CLLocation {
        return dependencies.defaultLocation
    }
}
