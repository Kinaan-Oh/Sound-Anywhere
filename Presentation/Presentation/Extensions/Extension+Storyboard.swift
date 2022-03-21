//
//  Extension+Storyboard.swift
//  Time Capsule
//
//  Created by 오현식 on 2022/03/07.
//

import UIKit

extension UIStoryboard {
    
    public enum ID: String {
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
}

extension UIStoryboard {
    
    public static func instantiateViewController(withID storyboardID: UIStoryboard.ID) -> UIViewController {
        
        let storyboard = UIStoryboard.init(name: storyboardID.stringValue,
                                           bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: storyboardID.stringValue)
    }
}
