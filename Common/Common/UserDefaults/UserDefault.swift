//
//  UserDefault.swift
//  Common
//
//  Created by 오현식 on 2022/04/16.
//

import Foundation

// Reference: 1. https://zeddios.tistory.com/1221 2. https://codesquad-yoda.medium.com/codable-vs-nscoding-%EC%B0%A8%EC%9D%B4%EC%A0%90-4b47e240c0b8

@propertyWrapper
public struct UserDefault<T> {
    let key: String
    let defaultValue: T
    let storage: UserDefaults

    public var wrappedValue: T {
        get { self.storage.object(forKey: self.key) as? T ?? self.defaultValue }
        set { self.storage.set(newValue, forKey: self.key) }
    }
    
    init(key: String, defaultValue: T, storage: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.storage = storage
    }
}

