//
//  Sound_AnywhereUITests.swift
//  Sound-AnywhereUITests
//
//  Created by 오현식 on 2022/05/25.
//

// Reference: https://developer.apple.com/videos/play/wwdc2020/10220/, https://developer.apple.com/videos/play/wwdc2015/406/

import XCTest

import Nimble

final class SoundAnywhereUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        
        app = XCUIApplication()
        app.resetAuthorizationStatus(for: .location)
        continueAfterFailure = false
    }
    
    // MARK: - authorizationStatus: notDetermined
    
    func test_allowOnce_then_CurrentLocationAnnotationExists() {
        app.launch()
        
        let monitor = addUIInterruptionMonitor(withDescription: "위치권한요청") { alert in
            if alert.labelContains(text: "사용자의 위치를 사용하도록 허용하겠습니까?") {
                alert.buttons["한 번 허용"].tap()
                return true
            }
            return false
        }
                
        app.swipeUp()
        expect(self.app.otherElements["현재 위치"].exists).to(equal(true))
        
        removeUIInterruptionMonitor(monitor)
    }
    
    func test_allowOnce_then_CurrentLocationButtonEnabled() {
        app.launch()
        
        let monitor = addUIInterruptionMonitor(withDescription: "위치권한요청") { alert in
            if alert.labelContains(text: "사용자의 위치를 사용하도록 허용하겠습니까?") {
                alert.buttons["한 번 허용"].tap()
                return true
            }
            return false
        }
        
        
        app.swipeUp()
        expect(self.app/*@START_MENU_TOKEN@*/.buttons["CurrentLocation"]/*[[".buttons[\"현재 위치\"]",".buttons[\"CurrentLocation\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.isEnabled).to(equal(true))
        
        removeUIInterruptionMonitor(monitor)
    }
    
    func test_allowWhenInUse_then_CurrentLocationAnnotationExists() {
        app.launch()
        
        let monitor = addUIInterruptionMonitor(withDescription: "위치권한요청") { alert in
            if alert.labelContains(text: "사용자의 위치를 사용하도록 허용하겠습니까?") {
                alert.buttons["앱을 사용하는 동안 허용"].tap()
                return true
            }
            return false
        }
        
        app.swipeUp()
        expect(self.app.otherElements["현재 위치"].exists).to(equal(true))
        
        removeUIInterruptionMonitor(monitor)
    }
    
    func test_allowWhenInUse_then_CurrentLocationButtonEnabled() {
        app.launch()
        
        let monitor = addUIInterruptionMonitor(withDescription: "위치권한요청") { alert in
            if alert.labelContains(text: "사용자의 위치를 사용하도록 허용하겠습니까?") {
                alert.buttons["앱을 사용하는 동안 허용"].tap()
                return true
            }
            return false
        }
        
        
        app.swipeUp()
        expect(self.app/*@START_MENU_TOKEN@*/.buttons["CurrentLocation"]/*[[".buttons[\"현재 위치\"]",".buttons[\"CurrentLocation\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.isEnabled).to(equal(true))
        
        removeUIInterruptionMonitor(monitor)
    }
    
    func test_doNotAllow_then_CurrentLocationAnnotationNotExists() {
        app.launch()
        
        let monitor = addUIInterruptionMonitor(withDescription: "위치권한요청") { alert in
            if alert.labelContains(text: "사용자의 위치를 사용하도록 허용하겠습니까?") {
                alert.buttons["허용 안 함"].tap()
                return true
            }
            return false
        }
        
        app.swipeUp()
        expect(self.app.otherElements["현재 위치"].exists).to(equal(false))
        
        removeUIInterruptionMonitor(monitor)
    }

    func test_doNotAllow_then_CurrentLocationButtonDisabled() {
        app.launch()
        
        let monitor = addUIInterruptionMonitor(withDescription: "위치권한요청") { alert in
            if alert.labelContains(text: "사용자의 위치를 사용하도록 허용하겠습니까?") {
                alert.buttons["허용 안 함"].tap()
                return true
            }
            return false
        }
        
        app.swipeUp()
        expect(self.app/*@START_MENU_TOKEN@*/.buttons["CurrentLocation"]/*[[".buttons[\"현재 위치\"]",".buttons[\"CurrentLocation\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.isEnabled).to(equal(false))
        
        removeUIInterruptionMonitor(monitor)
    }
    
    // MARK: - relaunch -> authorizationStatus: denied
    
    func test_denied_then_CurrentLocationAnnotationNotExists() {
        // When
        app.launch()
        
        let monitor = addUIInterruptionMonitor(withDescription: "위치권한요청") { alert in
            if alert.labelContains(text: "사용자의 위치를 사용하도록 허용하겠습니까?") {
                alert.buttons["허용 안 함"].tap()
                return true
            }
            return false
        }
        
        app.swipeUp()
        removeUIInterruptionMonitor(monitor)
        app.terminate()
        
        // Then
        app.launch()
        
        expect(self.app.otherElements["현재 위치"].exists).to(equal(false))
    }
    
    func test_denied_then_CurrentLocationButtonDisabled() {
        // When
        app.launch()
        
        let monitor = addUIInterruptionMonitor(withDescription: "위치권한요청") { alert in
            if alert.labelContains(text: "사용자의 위치를 사용하도록 허용하겠습니까?") {
                alert.buttons["허용 안 함"].tap()
                return true
            }
            return false
        }
        
        app.swipeUp()
        removeUIInterruptionMonitor(monitor)
        app.terminate()
        
        // Then
        app.launch()
        
        expect(self.app/*@START_MENU_TOKEN@*/.buttons["CurrentLocation"]/*[[".buttons[\"현재 위치\"]",".buttons[\"CurrentLocation\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.isEnabled).to(equal(false))
    }
    
    // MARK: - relaunch -> authorizationStatus: allowedWhenInUse

    func test_allowedWhenInUse_then_CurrentLocationAnnotationExists() {
        // When
        app.launch()
        
        let monitor = addUIInterruptionMonitor(withDescription: "위치권한요청") { alert in
            if alert.labelContains(text: "사용자의 위치를 사용하도록 허용하겠습니까?") {
                alert.buttons["앱을 사용하는 동안 허용"].tap()
                return true
            }
            return false
        }
        
        app.swipeUp()
        removeUIInterruptionMonitor(monitor)
        app.terminate()
        
        // Then
        app.launch()
        
        expect(self.app.otherElements["현재 위치"].exists).to(equal(true))
    }
    
    func test_allowedWhenInUse_then_CurrentLocationButtonEnabled() {
        // When
        app.launch()
        
        let monitor = addUIInterruptionMonitor(withDescription: "위치권한요청") { alert in
            if alert.labelContains(text: "사용자의 위치를 사용하도록 허용하겠습니까?") {
                alert.buttons["앱을 사용하는 동안 허용"].tap()
                return true
            }
            return false
        }
        
        app.swipeUp()
        removeUIInterruptionMonitor(monitor)
        app.terminate()
        
        // Then
        app.launch()
        
        expect(self.app/*@START_MENU_TOKEN@*/.buttons["CurrentLocation"]/*[[".buttons[\"현재 위치\"]",".buttons[\"CurrentLocation\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.isEnabled).to(equal(true))
    }
}

extension XCUIElement {
    func labelContains(text: String) -> Bool {
        let predicate = NSPredicate(format: "label CONTAINS %@", text)
        return staticTexts.matching(predicate).firstMatch.exists
    }
}
