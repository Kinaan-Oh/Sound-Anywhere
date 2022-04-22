//
//  UserDefaultOther.swift
//  Common
//
//  Created by 오현식 on 2022/04/22.
//

@propertyWrapper
public struct UserDefaultOther<T> where T : NSObject, T : NSCoding {
    let key: String
    let defaultValue: T?
    let storage: UserDefaults

    public var wrappedValue: T? {
        get {
            guard let data = self.storage.object(forKey: self.key) as? Data,
                  let value = try? NSKeyedUnarchiver.unarchivedObject(ofClass: T.self, from: data)
            else { return self.defaultValue }
            return value
        }
        set {
            guard let data = try? NSKeyedArchiver.archivedData(withRootObject: newValue!,
                                                               requiringSecureCoding: false)
            else { return }
            self.storage.set(data, forKey: self.key)
        }
    }
    
    init(key: String, defaultValue: T?, storage: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.storage = storage
    }
}
