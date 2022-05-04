//
//  DefaultCommandLocationManagerUseCaseTests.swift
//  DomainTests
//
//  Created by 오현식 on 2022/04/23.
//

import XCTest

import Domain

final class DefaultCommandCLLocationServiceUseCaseTests: XCTestCase {
    // Given
    var locationServiceMock: CLLocationServiceMock!
    var commandLocationManagerUseCase: DefaultCommandCLLocationServiceUseCase!
    
    override func setUp() {
        super.setUp()
        
        locationServiceMock = CLLocationServiceMock()
        commandLocationManagerUseCase = DefaultCommandCLLocationServiceUseCase(locationService: locationServiceMock)
    }

    func test_requestWhenInUseAuthorization() {
        // When
        commandLocationManagerUseCase.requestWhenInUseAuthorization()
        
        // Then
        XCTAssertTrue(locationServiceMock.requestWhenInUseAuthorization_Called)
    }
    
    func test_startUpdatingLocation() {
        // When
        commandLocationManagerUseCase.startUpdatingLocation()
        
        // Then
        XCTAssertTrue(locationServiceMock.startUpdatingLocation_Called)
    }
    
    func test_stopUpdatingLocation() {
        // When
        commandLocationManagerUseCase.stopUpdatingLocation()
        
        // Then
        XCTAssertTrue(locationServiceMock.stopUpdatingLocation_Called)
    }
}
