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
    }
}
