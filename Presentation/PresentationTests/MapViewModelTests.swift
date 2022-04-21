//
//  PresentationTests.swift
//  PresentationTests
//
//  Created by 오현식 on 2022/04/16.
//

import CoreLocation
import XCTest

@testable import Presentation
import RxCocoa
import RxSwift
import RxTest

final class MapViewModelTests: XCTestCase {
    // Given
    var locationManagerUseCaseMock: LocationManagerUseCaseMock!
    var viewModel: MapViewModel!
    var scheduler: TestScheduler!
    var disposeBag = DisposeBag()
    
    override func setUp() {
        super.setUp()
        
        locationManagerUseCaseMock = LocationManagerUseCaseMock()
        viewModel = MapViewModel(
            dependencies: .init(
                defaultLocation: CLLocation(),
                locationManagerUseCase: locationManagerUseCaseMock
            )
        )
        scheduler = TestScheduler(initialClock: 0)
    }
    
    func test_transform_viewDidAppearEvent_requestWhenInUseAuthorization() {
        // When
        let viewDidAppearEvent = scheduler.createColdObservable([.next(100, true)])
            .asDriverOnErrorJustComplete()
        let input = createInput(viewDidAppearEvent: viewDidAppearEvent)
        let output = viewModel.transform(input: input)
        
        scheduler.start()
        
        // Then
        XCTAssertTrue(locationManagerUseCaseMock.requestWhenInUseAuthorization_Called)
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
        XCTAssertTrue(locationManagerUseCaseMock.requestWhenInUseAuthorization_Called)
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
        XCTAssertTrue(locationManagerUseCaseMock.observeLocation_Called)
        XCTAssertEqual(res.events, [.next(0, nil), .completed(0)])
    }
    
    // MARK: - Input
    
    private func createInput(viewDidAppearEvent: Driver<Bool> = Driver.never()) -> MapViewModel.Input {
        return MapViewModel.Input(viewDidAppearEvent: viewDidAppearEvent)
    }
}
