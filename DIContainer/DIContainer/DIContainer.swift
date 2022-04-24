//
//  DIContainer.swift
//  DIContainer
//
//  Created by 오현식 on 2022/04/25.
//
// Reference: https://eunjin3786.tistory.com/233

public final class DIContainer {
    public static let shared = DIContainer()
    
    private init() {}
    private var dependencies: [String: Any] = [:]
    
    public func register<T>(dependency: T) {
        let key = String(describing: T.self)
        dependencies[key] = dependency
    }
    
    public func resolve<T>() -> T {
        let key = String(describing: T.self)
        
        guard let value = dependencies[key],
              let dependency = value as? T
        else { fatalError("register 되지 않음") }
        return dependency
    }
}
