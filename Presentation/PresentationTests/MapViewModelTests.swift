//
//  PresentationTests.swift
//  PresentationTests
//
//  Created by 오현식 on 2022/04/16.
//

import CoreLocation
import XCTest

@testable import Presentation
import Domain
import RxCocoa
import RxSwift
import RxTest

final class MapViewModelTests: XCTestCase {
    // Given
    var queryLocationManagerUseCaseStub: QueryLocationManagerUseCaseStub!
    var commandLocationManagerUseCaseMock: CommandLocationManagerUseCaseMock!
    var queryZoneUseCaseStub: QueryZoneUseCaseStub!
    var viewModel: MapViewModel!
    var scheduler: TestScheduler!
    var disposeBag = DisposeBag()
    
    override func setUp() {
        super.setUp()
        
        queryLocationManagerUseCaseStub = QueryLocationManagerUseCaseStub()
        commandLocationManagerUseCaseMock = CommandLocationManagerUseCaseMock()
        queryZoneUseCaseStub = QueryZoneUseCaseStub()
        viewModel = MapViewModel(dependencies:
                .init(defaultLocation: CLLocation(latitude: 37.54330366639085,
                                                  longitude: 127.04455548501139),
                      queryLocationManagerUseCase: queryLocationManagerUseCaseStub,
                      commandLocationManagerUseCase: commandLocationManagerUseCaseMock,
                      queryZoneUseCase: queryZoneUseCaseStub)
        )
        scheduler = TestScheduler(initialClock: 0)
    }
    
    // MARK: - Transform
    
    func test_transform_viewDidAppearEvent_requestWhenInUseAuthorization() {
        // When
        let viewDidAppearEvent = scheduler.createColdObservable([.next(100, true)])
            .mapToVoid()
            .asDriverOnErrorJustComplete()
        let sceneDidActivateNotificationEvent = scheduler.createColdObservable([.next(200, true)])
            .mapToVoid()
            .asDriverOnErrorJustComplete()
        
        let input = createInput(viewDidAppearEvent: viewDidAppearEvent,
                                sceneDidActivateNotificationEvent: sceneDidActivateNotificationEvent)
        let output = viewModel.transform(input: input)
        
        scheduler.start()
        
        // Then
        XCTAssertEqual(commandLocationManagerUseCaseMock.requestWhenInUseAuthorization_Called_Count,
                       2)
    }
    
    func test_transform_authorizationStatus() {
        // Given
        let res = scheduler.createObserver(CLAuthorizationStatus.self)
        
        // When
        let viewDidAppearEvent = scheduler.createColdObservable([.next(100, true)])
            .mapToVoid()
            .asDriverOnErrorJustComplete()
        let sceneDidActivateNotificationEvent = scheduler.createColdObservable([.next(200, true)])
            .mapToVoid()
            .asDriverOnErrorJustComplete()
        
        let input = createInput(viewDidAppearEvent: viewDidAppearEvent,
                                sceneDidActivateNotificationEvent: sceneDidActivateNotificationEvent)
        let output = viewModel.transform(input: input)
        
        output.authorizationStatus
            .drive(res)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        // Then
        XCTAssertEqual(res.events, [.next(0, .notDetermined), .completed(0)])
    }
    
    func test_transform_location() {
        // Given
        let res = scheduler.createObserver(CLLocation?.self)
        
        // When
        let viewDidAppearEvent = scheduler.createColdObservable([.next(100, true)])
            .mapToVoid()
            .asDriverOnErrorJustComplete()
        let sceneDidActivateNotificationEvent = scheduler.createColdObservable([.next(200, true)])
            .mapToVoid()
            .asDriverOnErrorJustComplete()
        
        let input = createInput(viewDidAppearEvent: viewDidAppearEvent,
                                sceneDidActivateNotificationEvent: sceneDidActivateNotificationEvent)
        let output = viewModel.transform(input: input)
        
        output.location
            .drive(res)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        // Then
        XCTAssertEqual(res.events, [.next(0, nil), .completed(0)])
    }
    
    func test_transform_zone() {
        // Given
        let res = scheduler.createObserver([Zone].self)
        
        // When
        let viewDidAppearEvent = scheduler.createColdObservable([.next(100, true)])
            .mapToVoid()
            .asDriverOnErrorJustComplete()
        let sceneDidActivateNotificationEvent = scheduler.createColdObservable([.next(200, true)])
            .mapToVoid()
            .asDriverOnErrorJustComplete()
        
        let input = createInput(viewDidAppearEvent: viewDidAppearEvent,
                                sceneDidActivateNotificationEvent: sceneDidActivateNotificationEvent)
        let output = viewModel.transform(input: input)
        
        output.zone
            .drive(res)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        // Then
        XCTAssertEqual(res.events, [.next(100, []), .next(200, []), .completed(200)])
    }
    
    // MARK: - Commanding
    
    func test_startUpdatingLocation() {
        // When
        viewModel.startUpdatingLocation()
        
        // Then
        XCTAssertTrue(commandLocationManagerUseCaseMock.startUpdatingLocation_Called)
    }
    
    func test_stopUpdatingLocation() {
        // When
        viewModel.stopUpdatingLocation()
        
        // Then
        XCTAssertTrue(commandLocationManagerUseCaseMock.stopUpdatingLocation_Called)
    }
    
    // MARK: - Querying
    
    func test_getDefaultLocation() {
        // When
        let res = viewModel.getDefaultLocation()
        
        // Then
        XCTAssertEqual(res.coordinate.latitude, 37.54330366639085)
        XCTAssertEqual(res.coordinate.longitude, 127.04455548501139)
    }
    
    // MARK: - Private Methods
    
    private func createInput(
        viewDidAppearEvent: Driver<Void> = Driver.never(),
        sceneDidActivateNotificationEvent: Driver<Void> = Driver.never()
    ) -> MapViewModel.Input {
        return MapViewModel.Input(viewDidAppearEvent: viewDidAppearEvent,
                                  sceneDidActivateNotificationEvent: sceneDidActivateNotificationEvent)
    }
}
