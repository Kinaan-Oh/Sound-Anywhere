//
//  DefaultQueryZoneUseCaseTests.swift
//  DomainTests
//
//  Created by 오현식 on 2022/04/25.
//

import XCTest

@testable import Domain
import RxSwift

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
        defaultQueryZoneUseCase.query()
            .subscribe(onSuccess: { result in
                XCTAssertEqual(result.first?.name, "stub")
            })
            .disposed(by: disposeBag)
    }
    
    func test_queryName() {
        // When
        defaultQueryZoneUseCase.query(name: "test")
            .subscribe(onSuccess: { result in
                // Then
                XCTAssertEqual(result.name, "stub")
            })
            .disposed(by: disposeBag)
    }
}
