//
//  UserDefaultsService.swift
//  Common
//
//  Created by 오현식 on 2022/04/19.
//

import CoreLocation

public final class UserDefaultsService {
    enum Key: String {
        case recentLocation
    }
    
    @UserDefault(key: Key.recentLocation.rawValue, defaultValue: nil)
    public static var recentLocation: Data?
}
