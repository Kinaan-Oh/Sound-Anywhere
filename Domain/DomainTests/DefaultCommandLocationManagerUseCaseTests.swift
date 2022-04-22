//
//  DefaultCommandLocationManagerUseCaseTests.swift
//  DomainTests
//
//  Created by 오현식 on 2022/04/23.
//

import XCTest

import Domain

final class CommandLocationManagerUseCaseTests: XCTestCase {
    // Given
    var locationManagerMock: CLLocationManagerMock!
    var commandLocationManagerUseCase: DefaultCommandLocationManagerUseCase!
    
    override func setUp() {
        super.setUp()
        
        locationManagerMock = CLLocationManagerMock()
        commandLocationManagerUseCase = DefaultCommandLocationManagerUseCase(locationManager: locationManagerMock)
    }

    func test_requestWhenInUseAuthorization() {
        // When
        commandLocationManagerUseCase.requestWhenInUseAuthorization()
        
        // Then
        XCTAssertTrue(locationManagerMock.requestWhenInUseAuthorization_Called)
    }
    
    func test_startUpdatingLocation() {
        // When
        commandLocationManagerUseCase.startUpdatingLocation()
        
        // Then
        XCTAssertTrue(locationManagerMock.startUpdatingLocation_Called)
    }
    
    func test_stopUpdatingLocation() {
        // When
        commandLocationManagerUseCase.stopUpdatingLocation()
        
        // Then
        XCTAssertTrue(locationManagerMock.stopUpdatingLocation_Called)
    }
}
