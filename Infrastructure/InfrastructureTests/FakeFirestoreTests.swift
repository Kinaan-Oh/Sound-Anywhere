//
//  FakeFirestoreTests.swift
//  DataTests
//
//  Created by 오현식 on 2022/04/16.
//

import CoreLocation
import XCTest

@testable import Data
import Domain
import Nimble
import RxTestPackage

final class FakeFirestoreTests: XCTestCase {
    // Given
    var fakeFirestore: FakeFirestore!
    var data: ZoneDTO!
    
    override func setUp() {
        super.setUp()
    
        fakeFirestore = FakeFirestore()
        let dummy = getDummy()
        data = dummy.first!
    }
    
    func test_setData_then_succeed() {
        // Then
        expect(self.fakeFirestore.setData(collection: "zone", document: "합정", data: self.data)).first
            .to(beNil())
    }
    
    func test_getDocument_then_succeed() {
        // When
        setData()
        
        // Then
        expect(self.fakeFirestore.getDocument(collection: "zone", document: "합정")).first == data
    }
    
    func test_getDocumentWhenDocumentNotExists_then_fail() {
        // Then
        expect(self.fakeFirestore.getDocument(collection: "zone", document: "합정")).first
            .to(throwError(FakeFirestore<ZoneDTO>.FakeFirestoreError.documentNotExist))
    }
    
    func test_getDocuments_then_succeed() {
        // When
        setData()
        
        // Then
        expect(self.fakeFirestore.getDocuments(collection: "zone")).first == [data]
    }
    
    func test_getDocumentsWhenDocumentsNotExist_then_fail() {
        // Then
        expect(self.fakeFirestore.getDocuments(collection: "zone")).first
            .to(throwError(FakeFirestore<ZoneDTO>.FakeFirestoreError.documentsNotExist))
    }
    
    private func getDummy() -> [ZoneDTO] {
        let path = Bundle(for: DefaultZoneRepositoryTests.self).path(forResource: "Zone", ofType: "json")
        let data = try? String(contentsOfFile: path!).data(using: .utf8)
        let dummy = try? JSONDecoder().decode([ZoneDTO].self, from: data!)
        return dummy!
    }
    
    private func setData() {
        fakeFirestore.db["zone"] = ["합정": data]
    }
}
