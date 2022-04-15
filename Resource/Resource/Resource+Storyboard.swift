//
//  Resource+Storyboard.swift
//  Resource
//
//  Created by 오현식 on 2022/03/22.
//

import UIKit
import Common

extension Resource {
    public class Storyboard {
        enum ID: String {
            case main
            case home
            case search
            case map
            case record
            case login
            case signUp
            case emailSignUp
            
            var stringValue: String {
                return self.rawValue.firstCharCapitalized
            }
        }
        
        let storyboard: UIStoryboard
        let id: ID
        
        init(id: ID) {
            self.id = id
            self.storyboard = UIStoryboard(name: id.stringValue, bundle: Resource.bundle)
        }
        
        public func instance<T: UIViewController>() -> T {
            storyboard.instantiateViewController(withIdentifier: id.stringValue) as! T
        }
    }
}

extension Resource.Storyboard {
    public typealias Storyboard = Resource.Storyboard
    
    public static var main: Storyboard { Storyboard(id: .main) }
    public static var home: Storyboard { Storyboard(id: .home) }
    public static var search: Storyboard { Storyboard(id: .search) }
    public static var map: Storyboard { Storyboard(id: .map) }
    public static var record: Storyboard { Storyboard(id: .record) }
    public static var login: Storyboard { Storyboard(id: .login) }
    public static var signUp: Storyboard { Storyboard(id: .signUp) }
    public static var emailSignUp: Storyboard { Storyboard(id: .emailSignUp) }
}
