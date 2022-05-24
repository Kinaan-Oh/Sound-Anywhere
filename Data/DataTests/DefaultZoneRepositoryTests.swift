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
import Nimble
import RxSwift
import RxTestPackage

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
    
    func test_query_then_succeed() {
        let dummy = getDummy()
        
        // When
        defaultZoneRepository.setDummy(dummy: dummy)
        
        // Then
        expect(self.defaultZoneRepository.query()).first == dummy.map { $0.toEntity() }
    }
    
    func test_query_then_fail() {
        let dummy = getDummy()
        
        // When
        expect(self.defaultZoneRepository.query()).first
            .to(throwError(FakeFirestore<ZoneDTO>.FirestoreError.documentsNotExist))
    }
    
    func test_queryName_then_succeed() {
        let dummy = getDummy()
        
        // When
        defaultZoneRepository.setDummy(dummy: dummy)
        
        // Then
        expect(self.defaultZoneRepository.query(name: "서울숲01")).first == dummy.first!.toEntity()
    }
    
    func test_queryName_then_fail() {
        // Then
        expect(self.defaultZoneRepository.query(name: "서울숲01")).first
            .to(throwError(FakeFirestore<ZoneDTO>.FirestoreError.documentNotExist))
    }
    
    func test_saveZone_then_succeed() {
        let zone = Zone(id: "006", name: "서울숲06", trackList: [], coordinate: CLLocationCoordinate2D() )
        
        // When
        expect(self.defaultZoneRepository.save(data: zone)).first
            .to(beNil())
    
        // Then
        let collection = fakeFirestore.db["zone"]
        let document = collection?.collection["서울숲06"]
        let result = document?.data?.toEntity()
        
        expect(result) == zone
    }
    
    func test_save_then_fail() {
        let dummy = getDummy()
        let zone = dummy.first!.toEntity()
        
        // When
        defaultZoneRepository.setDummy(dummy: dummy)
        
        // Then
        expect(self.defaultZoneRepository.save(data: zone)).first
            .to(throwError(FakeFirestore<ZoneDTO>.FirestoreError.documentAleadyExist))
    }
    
    private func getDummy() -> [ZoneDTO] {
        let path = Bundle(for: DefaultZoneRepositoryTests.self).path(forResource: "Zone", ofType: "json")
        let data = try? String(contentsOfFile: path!).data(using: .utf8)
        let dummy = try? JSONDecoder().decode([ZoneDTO].self, from: data!)
        return dummy!
    }
}
