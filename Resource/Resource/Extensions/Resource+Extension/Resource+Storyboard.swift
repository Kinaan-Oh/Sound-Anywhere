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
            case map
            
            public var stringValue: String {
                return self.rawValue.firstCharCapitalized
            }
        }
        
        private let id: String
        private let storyboard: UIStoryboard
        
        public init(id: ID) {
            self.id = id.stringValue
            storyboard = UIStoryboard(name: id.stringValue, bundle: Resource.bundle)
        }
        
        public func instance<T: UIViewController>() -> T {
            guard let instance = storyboard.instantiateViewController(withIdentifier: id) as? T else {
                fatalError("Resource.Storyboard.instance Failed!")
            }
            return instance
        }
    }
}
