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
    
    override func setUp() {
        super.setUp()
        
        fakeFirestore = FakeFirestore<ZoneDTO>()
    }
    
    func test_setData_getDocument() {
        // Given
        let track = TrackDTO(id: "001",
                             imageURLString: "https://i.scdn.co/image/ab67616d00001e02ff9ca10b55ce82ae553c8228",
                             genres: [],
                             album: "Dance",
                             artist: "Seinabo Sey",
                             title: "Younger",
                             description: "")
        let trackList = [track]
        let coordinate = CLLocationCoordinate2D(latitude: 77,
                                                longitude: 77)
        let input = ZoneDTO(id: "001", name: "서울숲", trackList: trackList, coordinate: coordinate)
        
        // When
        fakeFirestore.collection(name: "zone")
            .document(name: "서울숲")
            .setData(from: input)
        
        // Then
        
        // 1. setData Test
        let collection = fakeFirestore.db["zone"]
        XCTAssertNotNil(collection)
        
        let document = collection!.collection["서울숲"]
        XCTAssertNotNil(document)
        
        let data = document!.data
        XCTAssertEqual(input, data)
        
        // 2. getDocument Test
        fakeFirestore
            .collection(name: "zone")
            .document(name: "서울숲")
            .getDocument { output in
                XCTAssertEqual(output, .success(input))
            }
    }
}
