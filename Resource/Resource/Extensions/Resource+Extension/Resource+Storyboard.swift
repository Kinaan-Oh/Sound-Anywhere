//
//  Resource+Storyboard.swift
//  Resource
//
//  Created by 오현식 on 2022/03/22.
//

import UIKit

import Common

extension Resource {
    public final class Storyboard {
        public enum ID: String {
            case main
            case home
            case search
            case map
            case record
            case login
            case signUp
            case emailSignUp
            
            public var stringValue: String {
                return self.rawValue.firstCharCapitalized
            }
        }
    }
}
