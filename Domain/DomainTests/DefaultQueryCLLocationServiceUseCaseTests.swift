//
//  QueryLocationManagerUseCaseTests.swift
//  DomainTests
//
//  Created by 오현식 on 2022/04/23.
//

import CoreLocation
import XCTest

@testable import Domain
import Nimble
import RxSwift
import RxTestPackage

final class DefaultQueryCLLocationServiceUseCaseTests: XCTestCase {
    // Given
    var locationServiceStub: CLLocationServiceStub!
    var defaultQueryLocationManagerUseCase: DefaultQueryCLLocationServiceUseCase!
    var scheduler: TestScheduler!
    var disposeBag = DisposeBag()

    override func setUp() {
        super.setUp()

        locationServiceStub = CLLocationServiceStub()
        defaultQueryLocationManagerUseCase = DefaultQueryCLLocationServiceUseCase(locationService: locationServiceStub)
        scheduler = TestScheduler(initialClock: 0)
    }

    func test_queryInitialAuthorizationStatus() {
        expect(self.defaultQueryLocationManagerUseCase.queryInitialAuthorizationStatus()) == CLAuthorizationStatus.notDetermined
        
    }
    
    func test_observeAuthorizationStatus() {
        expect(self.defaultQueryLocationManagerUseCase.observeAuthorizationStatus()).array == [
            .notDetermined
        ]
    }

    func test_observeLocation() {
        expect(self.defaultQueryLocationManagerUseCase.observeLocation).array == [nil]
    }
}
