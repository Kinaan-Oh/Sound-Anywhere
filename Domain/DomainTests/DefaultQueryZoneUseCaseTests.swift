//
//  DefaultQueryZoneUseCaseTests.swift
//  DomainTests
//
//  Created by 오현식 on 2022/04/25.
//

import CoreLocation
import XCTest

@testable import Domain
import Nimble
import RxSwift
import RxTestPackage

final class DefaultQueryZoneUseCaseTests: XCTestCase {
    // Given
    var defaultQueryZoneUseCase: DefaultQueryZoneUseCase!
    var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()
        
        defaultQueryZoneUseCase = DefaultQueryZoneUseCase(zoneRepository: ZoneRepositoryStub())
        disposeBag = DisposeBag()
    }

    func test_query() {
        // When
        expect(self.defaultQueryZoneUseCase.query()).first == [
            Zone(id: "",
                 name: "합정",
                 trackList: [],
                 coordinate: CLLocationCoordinate2D())
        ]
    }
    
    func test_queryName() {
        // When
        expect(self.defaultQueryZoneUseCase.query(name: "test")).first == Zone(id: "",
                                                                               name: "합정",
                                                                               trackList: [],
                                                                               coordinate: CLLocationCoordinate2D())
    }
}
