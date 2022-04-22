//
//  CommonTests.swift
//  CommonTests
//
//  Created by 오현식 on 2022/04/22.
//

import CoreLocation
import XCTest

@testable import Common

final class UserDefaultsServiceTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    func test_recentLocation() {
        // given
        let location = CLLocation(latitude: 37.54330366639085, longitude: 127.04455548501139)
        
        // when
        UserDefaultsService.recentLocation = location
        
        // then
        let key = UserDefaultsService.Keys.recentLocation.rawValue
        let data = UserDefaults.standard.data(forKey: key)
        XCTAssertNotNil(data)
        
        let ret = try? NSKeyedUnarchiver.unarchivedObject(ofClass: CLLocation.self, from: data!)
        XCTAssertNotNil(ret)
        
        XCTAssertEqual(location.coordinate.latitude, ret!.coordinate.latitude)
        XCTAssertEqual(location.coordinate.longitude, ret!.coordinate.longitude)
    }
}
