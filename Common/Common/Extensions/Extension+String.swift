//
//  Extension+String.swift
//  Time Capsule
//
//  Created by 오현식 on 2022/03/14.
//

import Foundation

extension String {
    
    public var firstCharCapitalized: String {
        return prefix(1).uppercased() + dropFirst()
    }
}
