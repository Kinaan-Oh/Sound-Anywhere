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
}

public protocol MapViewModelOutputs {
    /// The starting value of the location.
    var defaultLocation: CLLocation { get }
    
    /// Emits a current location that should be annotated in the map view.
    var currentLocation: Driver<CLLocation?> { get }
    
    /// Emits when authorization when in use was requested.
    var authorizationWhenInUseRequested: Driver<Void> { get }
    
    /// Emits an authorization status that should be used to decide to annotate the current location.
    var authorizationStatus: Driver<CLAuthorizationStatus> { get }
    
    /// Emits array of zones that should be annotated in the map view.
    var zones: Driver<[Zone]> { get }
}

public protocol MapViewModelType {
    var inputs: MapViewModelInputs { get }
    var outputs: MapViewModelOutputs { get }
}

final class MapViewModel: MapViewModelInputs, MapViewModelOutputs, MapViewModelType {
    // MARK: - Initializer
    
    public init(defaultLocation: CLLocation,
                queryCLLocationServiceUseCase: QueryCLLocationServiceUseCase,
                commandCLLocationServiceUseCase: CommandCLLocationServiceUseCase,
                queryZoneUseCase: QueryZoneUseCase
    ) {
        self.defaultLocation = defaultLocation
        
        self.currentLocation = queryCLLocationServiceUseCase.observeLocation()
            .asDriverOnErrorJustComplete()
        
        self.authorizationWhenInUseRequested = Observable
            .merge(viewDidAppearRelay.asObservable(),
                   sceneDidActivateRelay.asObservable()
            )
            .map { _ in commandCLLocationServiceUseCase.requestWhenInUseAuthorization() }
            .asDriverOnErrorJustComplete()
        
        self.authorizationStatus = queryCLLocationServiceUseCase.observeAuthorizationStatus()
            .asDriverOnErrorJustComplete()
        
        self.zones = viewDidAppearRelay.asObservable()
            .flatMapLatest { _ in return queryZoneUseCase.query() }
            .asDriverOnErrorJustComplete()
    }
    
    // MARK: - MapViewModelInputs
    
    private let sceneDidActivateRelay = PublishRelay<Void>()
    public func sceneDidActivate() {
        sceneDidActivateRelay.accept(())
    }
    
    private let viewDidAppearRelay = PublishRelay<Void>()
    public func viewDidAppear() {
        viewDidAppearRelay.accept(())
    }
    
    // MARK: - MapViewModelOutputs
    
    public let defaultLocation: CLLocation
    public let currentLocation: Driver<CLLocation?>
    public let authorizationWhenInUseRequested: Driver<Void>
    public let authorizationStatus: Driver<CLAuthorizationStatus>
    public let zones: Driver<[Zone]>
    
    // MARK: - MapViewModelType
    
    public var inputs: MapViewModelInputs { return self }
    public var outputs: MapViewModelOutputs { return self }
}
