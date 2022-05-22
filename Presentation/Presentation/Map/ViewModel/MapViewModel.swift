//
//  MapViewModel.swift
//  Presentation
//
//  Created by 오현식 on 2022/05/16.
//

import CoreLocation

import Domain
import RxCocoa
import RxSwift

public protocol MapViewModelInputs {
    /// Call when the scene is activated.
    func sceneDidActivate()
    
    /// Call when the view appeared with animated property.
    func viewDidAppear()
    
    /// Call when location service is needed.
    func startUpdatingLocation()
    
    /// Call when location service is not needed. This can help improve power performance.
    func stopUpdatingLocation()
}

public protocol MapViewModelOutputs {
    /// The starting value of the location.
    var defaultLocation: CLLocation { get }
    
    /// Emits a current location that should be annotated in the map view.
    var currentLocation: Driver<CLLocation?> { get }

    /// The initial authorization status emitted when location service initiated.
    var initialAuthorizationStatus: CLAuthorizationStatus? { get }

    /// Emits an authorization status that should be used to decide to annotate the current location.
    var authorizationStatus: Driver<CLAuthorizationStatus> { get }
    
    /// Emits array of zones that should be annotated in the map view.
    var zones: Driver<[Zone]> { get }
}

public protocol MapViewModelType {
    var inputs: MapViewModelInputs { get }
    var outputs: MapViewModelOutputs { get }
}

public final class MapViewModel: MapViewModelInputs, MapViewModelOutputs, MapViewModelType {
    
    // MARK: - Initializer
    
    public init(defaultLocation: CLLocation,
                queryCLLocationServiceUseCase: QueryCLLocationServiceUseCase,
                commandCLLocationServiceUseCase: CommandCLLocationServiceUseCase,
                queryZoneUseCase: QueryZoneUseCase
    ) {
        
        // MARK: - Configure Dependencies

        self.queryCLLocationServiceUseCase = queryCLLocationServiceUseCase
        self.commandCLLocationServiceUseCase = commandCLLocationServiceUseCase
        self.queryZoneUseCase = queryZoneUseCase
        
        // MARK: - Subscribe Inputs
        
        Observable
            .merge(viewDidAppearRelay.asObservable(),
                   sceneDidActivateRelay.asObservable()
            )
            .subscribe(onNext: { _ in
                commandCLLocationServiceUseCase.requestWhenInUseAuthorization()
            })
            .disposed(by: disposeBag)
        
        updateLocationRelay.asObservable()
            .subscribe(onNext: { updateLocation in
                if updateLocation {
                    commandCLLocationServiceUseCase.startUpdatingLocation()
                } else {
                    commandCLLocationServiceUseCase.stopUpdatingLocation()
                }
            })
            .disposed(by: disposeBag)

        // MARK: - Configure Outputs
        
        self.defaultLocation = defaultLocation
        
        self.currentLocation = queryCLLocationServiceUseCase.observeLocation()
            .asDriverOnErrorJustComplete()
        
        self.authorizationStatus = queryCLLocationServiceUseCase.observeAuthorizationStatus()
            .asDriverOnErrorJustComplete()
        
        self.zones = viewDidAppearRelay.asObservable()
            .flatMapLatest { _ in return queryZoneUseCase.query() }
            .asDriverOnErrorJustComplete()
    }
    
    // MARK: - Private Properties
    
    private var disposeBag = DisposeBag()
    
    // MARK: - Dependencies

    private let queryCLLocationServiceUseCase: QueryCLLocationServiceUseCase
    private let commandCLLocationServiceUseCase: CommandCLLocationServiceUseCase
    private let queryZoneUseCase: QueryZoneUseCase

    // MARK: - MapViewModelInputs
    
    private let sceneDidActivateRelay = PublishRelay<Void>()
    public func sceneDidActivate() {
        sceneDidActivateRelay.accept(())
    }
    
    private let viewDidAppearRelay = PublishRelay<Void>()
    public func viewDidAppear() {
        viewDidAppearRelay.accept(())
    }
    
    private let updateLocationRelay = PublishRelay<Bool>()
    public func startUpdatingLocation() {
        updateLocationRelay.accept(true)
    }
    public func stopUpdatingLocation() {
        updateLocationRelay.accept(false)
    }
    
    // MARK: - MapViewModelOutputs
    
    public let defaultLocation: CLLocation
    public let currentLocation: Driver<CLLocation?>
    public var initialAuthorizationStatus: CLAuthorizationStatus? {
        return queryCLLocationServiceUseCase.queryInitialAuthorizationStatus()
    }
    public let authorizationStatus: Driver<CLAuthorizationStatus>
    public let zones: Driver<[Zone]>
    
    // MARK: - MapViewModelType
    
    public var inputs: MapViewModelInputs { return self }
    public var outputs: MapViewModelOutputs { return self }
}
