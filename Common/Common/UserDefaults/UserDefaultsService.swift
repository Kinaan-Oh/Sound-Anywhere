//
//  UserDefaultsService.swift
//  Common
//
//  Created by 오현식 on 2022/04/19.
//

import CoreLocation

public final class UserDefaultsService {
    enum Keys: String {
        case recentLocation
    }
    
    @UserDefaultOther(key: Keys.recentLocation.rawValue, defaultValue: nil)
    public static var recentLocation: CLLocation?
}
