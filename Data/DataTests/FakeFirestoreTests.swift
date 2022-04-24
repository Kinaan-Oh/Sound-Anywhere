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

final class FakeFirestoreTests: XCTestCase {
    // Given
    var fakeFirestore: FakeFirestore<ZoneDTO>!
    var input: ZoneDTO!
    
    override func setUp() {
        super.setUp()
        
        fakeFirestore = FakeFirestore<ZoneDTO>()
        let track = TrackDTO(id: "001",
                             imageURLString: "https://i.scdn.co/image/ab67616d00001e02ff9ca10b55ce82ae553c8228",
                             genres: [],
                             album: "Dance",
                             artist: "Seinabo Sey",
                             title: "Younger",
                             description: "")
        input = ZoneDTO(id: "001", name: "서울숲", latitude: 77, longitude: 77, trackList: [track])
    }
    
    func test_setData() {
        // When
        fakeFirestore.collection(name: "zone")
            .document(name: "서울숲")
            .setData(from: input) { [weak self] result in
                guard let self = self else { return }
                // Then
                switch result {
                case.success(let ret):
                    XCTAssertEqual(ret, self.input)
                case.failure(let error):
                    XCTAssertEqual(error, .documentAleadyExist)
                }
            }
        
        // Then
        let collection = fakeFirestore.db["zone"]
        XCTAssertNotNil(collection)
        
        let document = collection!.collection["서울숲"]
        XCTAssertNotNil(document)
        
        let data = document!.data
        XCTAssertEqual(input, data)
    }
    
    func test_getDocument() {
        // Given
        setInput()
        
        // When
        fakeFirestore
            .collection(name: "zone")
            .document(name: "서울숲")
            .getDocument { [weak self] result in
                guard let self = self else { return }
                // Then
                switch result {
                case .success(let ret):
                    XCTAssertEqual(ret, self.input)
                case .failure(let error):
                    XCTAssertEqual(error, .documentNotExist)
                }
            }
    }
    
    func test_getDocuments() {
        // Given
        setInput()
        
        // When
        fakeFirestore
            .collection(name: "zone")
            .getDocuments { [weak self] result in
                guard let self = self else { return }
                // Then
                switch result {
                case .success(let ret):
                    XCTAssertEqual(ret, [self.input])
                case .failure(let error):
                    XCTAssertEqual(error, .documentsNotExist)
                }
            }
    }
    
    // MARK: - set input
    
    private func setInput() {
        fakeFirestore.db["zone"] = FakeFirestore.Collection()
        fakeFirestore.db["zone"]!.collection[input.name] = FakeFirestore.Collection.Document()
        fakeFirestore.db["zone"]!.collection[input.name]!.data = input
    }
}
