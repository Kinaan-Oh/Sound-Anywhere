//
//  QueryLocationManagerUseCaseTests.swift
//  DomainTests
//
//  Created by 오현식 on 2022/04/23.
//

import CoreLocation
import XCTest

@testable import Domain
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

    func test_observeAuthorizationStatus() {
        // Given
        let res = scheduler.createObserver(CLAuthorizationStatus.self)

        // When
        defaultQueryLocationManagerUseCase
            .observeAuthorizationStatus()
            .bind(to: res)
            .disposed(by: disposeBag)

        // Then
        XCTAssertEqual(res.events, [.next(0, .notDetermined), .completed(0)])
    }

    func test_observeLocation() {
        // Given
        let res = scheduler.createObserver(CLLocation?.self)

        // When
        defaultQueryLocationManagerUseCase
            .observeLocation()
            .bind(to: res)
            .disposed(by: disposeBag)

        // Then
        XCTAssertEqual(res.events, [.next(0, nil), .completed(0)])
    }
}
