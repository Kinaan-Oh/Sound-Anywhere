//
//  DefaultZoneRepositoryTests.swift
//  DataTests
//
//  Created by 오현식 on 2022/04/25.
//

import CoreLocation
import XCTest

@testable import Data
import Domain
import RxSwift

final class DefaultZoneRepositoryTests: XCTestCase {
    // Given
    var fakeFirestore: FakeFirestore<ZoneDTO>!
    var defaultZoneRepository: DefaultZoneRepository<FakeFirestore<ZoneDTO>>!
    var disposeBag: DisposeBag!
    
    override func setUp() {
        super.setUp()
        
        fakeFirestore = FakeFirestore<ZoneDTO>()
        defaultZoneRepository = DefaultZoneRepository<FakeFirestore<ZoneDTO>>(firestore: fakeFirestore)
        disposeBag = DisposeBag()
    }
    
    func test_query_succeed() {
        // Given
        let path = Bundle(for: DefaultZoneRepositoryTests.self).path(forResource: "Zone", ofType: "json")
        XCTAssertNotNil(path)
        
        let data = try? String(contentsOfFile: path!).data(using: .utf8)
        XCTAssertNotNil(data)
        
        let dummy = try? JSONDecoder().decode([ZoneDTO].self, from: data!)
        XCTAssertNotNil(dummy)
        
        let expect = dummy!.map { $0.toEntity() }
        
        // When
        defaultZoneRepository.setDummy(dummy: dummy!)
        
        defaultZoneRepository.query()
            .subscribe { result in
                // Then
                XCTAssertEqual(result.sorted(by: { z1, z2 in z1.id<z2.id }), expect)
            } onFailure: { error in
            }
            .disposed(by: disposeBag)
    }
    
    func test_query_failed() {
        // Given
        let path = Bundle(for: DefaultZoneRepositoryTests.self).path(forResource: "Zone", ofType: "json")
        XCTAssertNotNil(path)
        
        let data = try? String(contentsOfFile: path!).data(using: .utf8)
        XCTAssertNotNil(data)
        
        let dummy = try? JSONDecoder().decode([ZoneDTO].self, from: data!)
        XCTAssertNotNil(dummy)
        
        let expect = dummy!.map { $0.toEntity() }
        
        // When
        defaultZoneRepository.query()
            .subscribe { result in
            } onFailure: { error in
                // Then
                let error = error as? FakeFirestore<ZoneDTO>.FirestoreError
                XCTAssertNotNil(error)
                XCTAssertEqual(error!, FakeFirestore<ZoneDTO>.FirestoreError.documentsNotExist)
            }
            .disposed(by: disposeBag)
    }
    
    func test_queryName_succeed() {
        // Given
        let path = Bundle(for: DefaultZoneRepositoryTests.self).path(forResource: "Zone", ofType: "json")
        XCTAssertNotNil(path)
        
        let data = try? String(contentsOfFile: path!).data(using: .utf8)
        XCTAssertNotNil(data)
        
        let dummy = try? JSONDecoder().decode([ZoneDTO].self, from: data!)
        XCTAssertNotNil(dummy)
        
        let expect = dummy!.first?.toEntity()
        XCTAssertNotNil(expect)
        
        // When
        defaultZoneRepository.setDummy(dummy: dummy!)
        
        defaultZoneRepository.query(name: "서울숲01")
            .subscribe { result in
                // Then
                XCTAssertEqual(result, expect!)
            } onFailure: { error in
            }
            .disposed(by: disposeBag)
    }
    
    func test_queryName_failed() {
        // Given
        let path = Bundle(for: DefaultZoneRepositoryTests.self).path(forResource: "Zone", ofType: "json")
        XCTAssertNotNil(path)
        
        let data = try? String(contentsOfFile: path!).data(using: .utf8)
        XCTAssertNotNil(data)
        
        let dummy = try? JSONDecoder().decode([ZoneDTO].self, from: data!)
        XCTAssertNotNil(dummy)
        
        let expect = dummy!.first?.toEntity()
        XCTAssertNotNil(expect)
        
        // When
        defaultZoneRepository.query(name: "서울숲01")
            .subscribe { result in
            } onFailure: { error in
                // Then
                print("-------------------------------------------------------------------------")
                print(error)
                print("-------------------------------------------------------------------------")
                let error = error as? FakeFirestore<ZoneDTO>.FirestoreError
                XCTAssertNotNil(error)
                XCTAssertEqual(error!, FakeFirestore<ZoneDTO>.FirestoreError.documentNotExist)
            }
            .disposed(by: disposeBag)
    }
    
    func test_save_succeed() {
        // Given
        let input = Zone(id: "006", name: "서울숲06", trackList: [], coordinate: CLLocationCoordinate2D() )
        
        // When
        defaultZoneRepository.save(data: input)
            .subscribe()
            .disposed(by: disposeBag)
        
        
        // Then
        let collection = fakeFirestore.db["zone"]
        XCTAssertNotNil(collection)
        
        let document = collection!.collection["서울숲06"]
        XCTAssertNotNil(document)
        
        let result = document!.data?.toEntity()
        XCTAssertNotNil(result)
        
        XCTAssertEqual(result, input)
    }
    
    func test_save_failed() {
        // Given
        let path = Bundle(for: DefaultZoneRepositoryTests.self).path(forResource: "Zone", ofType: "json")
        XCTAssertNotNil(path)
        
        let data = try? String(contentsOfFile: path!).data(using: .utf8)
        XCTAssertNotNil(data)
        
        let dummy = try? JSONDecoder().decode([ZoneDTO].self, from: data!)
        XCTAssertNotNil(dummy)
        
        let input = dummy?.first?.toEntity()
        XCTAssertNotNil(input)
        
        // When
        defaultZoneRepository.setDummy(dummy: dummy!)
        
        defaultZoneRepository.save(data: input!)
            .subscribe(onError: { error in
                let error = error as? FakeFirestore<ZoneDTO>.FirestoreError
                XCTAssertNotNil(error)
                XCTAssertEqual(error!, FakeFirestore<ZoneDTO>.FirestoreError.documentAleadyExist)
            })
            .disposed(by: disposeBag)
    }
}
