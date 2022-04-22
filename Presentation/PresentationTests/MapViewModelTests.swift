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
    var viewModel: MapViewModel!
    var scheduler: TestScheduler!
    var disposeBag = DisposeBag()
    
    override func setUp() {
        super.setUp()
        
        queryLocationManagerUseCaseStub = QueryLocationManagerUseCaseStub()
        commandLocationManagerUseCaseMock = CommandLocationManagerUseCaseMock()
        viewModel = MapViewModel(dependencies:
                .init(defaultLocation: CLLocation(latitude: 37.54330366639085,
                                                  longitude: 127.04455548501139),
                      queryLocationManagerUseCase: queryLocationManagerUseCaseStub,
                      commandLocationManagerUseCase: commandLocationManagerUseCaseMock)
        )
        scheduler = TestScheduler(initialClock: 0)
    }
    
    
    // MARK: - Transform
    
    func test_transform_viewDidAppearEvent_requestWhenInUseAuthorization() {
        // When
        let viewDidAppearEvent = scheduler.createColdObservable([.next(100, true)])
            .asDriverOnErrorJustComplete()
        let input = createInput(viewDidAppearEvent: viewDidAppearEvent)
        let output = viewModel.transform(input: input)
        
        scheduler.start()
        
        // Then
        XCTAssertTrue(commandLocationManagerUseCaseMock.requestWhenInUseAuthorization_Called)
    }
    
    func test_transform_authorizationStatus() {
        // Given
        let res = scheduler.createObserver(CLAuthorizationStatus.self)
        
        // When
        let viewDidAppearEvent = scheduler.createColdObservable([.next(100, true)])
            .asDriverOnErrorJustComplete()
        let input = createInput(viewDidAppearEvent: viewDidAppearEvent)
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
            .asDriverOnErrorJustComplete()
        let input = createInput(viewDidAppearEvent: viewDidAppearEvent)
        let output = viewModel.transform(input: input)
        
        output.location
            .drive(res)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        // Then
        XCTAssertEqual(res.events, [.next(0, nil), .completed(0)])
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
    
    private func createInput(viewDidAppearEvent: Driver<Bool> = Driver.never()) -> MapViewModel.Input {
        return MapViewModel.Input(viewDidAppearEvent: viewDidAppearEvent)
    }
}
