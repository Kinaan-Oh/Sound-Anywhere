//
//  UserDefaultsService.swift
//  Common
//
//  Created by 오현식 on 2022/04/19.
//

import CoreLocation

final public class UserDefaultsService {
    enum Keys: String {
        case authorizationStatus
    }
    
    @UserDefault(key: Keys.authorizationStatus.rawValue, defaultValue: CLAuthorizationStatus.notDetermined.rawValue)
    public static var authorizationStatusRawValue: CLAuthorizationStatus.RawValue
    public static var authorizationStatus: CLAuthorizationStatus {
        get { CLAuthorizationStatus.init(rawValue: authorizationStatusRawValue)! }
        set { authorizationStatusRawValue = newValue.rawValue }
    }
}
