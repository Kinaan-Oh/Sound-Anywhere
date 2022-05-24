//
//  DefaultCommandLocationManagerUseCaseTests.swift
//  DomainTests
//
//  Created by 오현식 on 2022/04/23.
//

import XCTest

@testable import Domain
import Nimble
import RxTestPackage

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
        expect(self.locationServiceMock.requestWhenInUseAuthorization_Called) == true
    }
    
    func test_startUpdatingLocation() {
        // When
        commandLocationManagerUseCase.startUpdatingLocation()
        
        // Then
        expect(self.locationServiceMock.startUpdatingLocation_Called) == true
    }
    
    func test_stopUpdatingLocation() {
        // When
        commandLocationManagerUseCase.stopUpdatingLocation()
        
        // Then
        expect(self.locationServiceMock.stopUpdatingLocation_Called) == true
    }
}
