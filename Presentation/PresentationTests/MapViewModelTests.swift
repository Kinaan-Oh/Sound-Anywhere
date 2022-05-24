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
import Nimble
import RxCocoa
import RxSwift
import RxTestPackage

final class MapViewModelTests: XCTestCase {
    var queryCLLocationServiceUseCaseStub: QueryCLLocationServiceUseCaseStub!
    var commandCLLocationServiceUseCaseMock: CommandCLLocationServiceUseCaseMock!
    var queryZoneUseCaseStub: QueryZoneUseCaseStub!
    var viewModel: MapViewModel!
    var scheduler: TestScheduler!
    var disposeBag = DisposeBag()
    
    override func setUp() {
        super.setUp()
        
        queryCLLocationServiceUseCaseStub = QueryCLLocationServiceUseCaseStub()
        commandCLLocationServiceUseCaseMock = CommandCLLocationServiceUseCaseMock()
        queryZoneUseCaseStub = QueryZoneUseCaseStub()
        viewModel = MapViewModel(defaultLocation: CLLocation(latitude: 37.54887101,
                                                             longitude: 126.91332598),
                                 queryCLLocationServiceUseCase: queryCLLocationServiceUseCaseStub,
                                 commandCLLocationServiceUseCase: commandCLLocationServiceUseCaseMock,
                                 queryZoneUseCase: queryZoneUseCaseStub)
        scheduler = TestScheduler(initialClock: 0)
    }
    
    func test_sceneDidActivate_then_requestWhenInUseAuthorization() {
        // When
        viewModel.inputs.sceneDidActivate()
        
        // Then
        expect(self.commandCLLocationServiceUseCaseMock.requestWhenInUseAuthorization_Called_Count) == 1
    }
    
    func test_viewDidAppear_then_requestWhenInUseAuthorization() {
        // When
        viewModel.inputs.viewDidAppear()
        
        // Then
        expect(self.commandCLLocationServiceUseCaseMock.requestWhenInUseAuthorization_Called_Count) == 1
    }
    
    func test_startUpdatingLocation_then_startUpdatingLocationCalled() {
        // When
        viewModel.inputs.startUpdatingLocation()
        
        // Then
        expect(self.commandCLLocationServiceUseCaseMock.startUpdatingLocation_Called) == true
    }
    
    func test_stopUpdatingLocation_then_stopUpdatingLocationCalled() {
        // When
        viewModel.inputs.stopUpdatingLocation()
        
        // Then
        expect(self.commandCLLocationServiceUseCaseMock.stopUpdatingLocation_Called) == true
    }
    
    func test_viewDidAppear_then_queryZones() {
        // When
        scheduler.createColdObservable(
            [
                .next(10, ()),
                .next(20, ()),
                .next(30, ())
            ]
        )
        .subscribe { [weak self] _ in
            guard let self = self else { return }
            self.viewModel.inputs.viewDidAppear()
        }
        .disposed(by: disposeBag)
       
        // Then
        expect(self.viewModel.outputs.zones)
            .events(scheduler: scheduler, disposeBag: disposeBag)
            .to(equal([
                Recorded.next(10, []),
                Recorded.next(20, []),
                Recorded.next(30, [])
            ]))
    }
    
    func test_authorizationStatus() {
        expect(self.viewModel.outputs.authorizationStatus).array == [CLAuthorizationStatus.notDetermined]
    }
    
    func test_currentLocation() {
        expect(self.viewModel.outputs.currentLocation).array == [nil]
    }
    
    func test_initialAuthorizationStatus() {
        expect(self.viewModel.outputs.initialAuthorizationStatus) == CLAuthorizationStatus.notDetermined
    }
    
    func test_defaultLocation() {
        expect(self.viewModel.outputs.defaultLocation.coordinate) == CLLocationCoordinate2D(latitude: 37.54887101,
                                                                                            longitude: 126.91332598)
    }
}
