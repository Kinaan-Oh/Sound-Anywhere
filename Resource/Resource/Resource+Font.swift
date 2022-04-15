//
//  Resource+Front.swift
//  Resource
//
//  Created by 오현식 on 2022/04/14.
//

import UIKit

public extension Resource {
    enum Font {}
}

public extension Resource.Font {
    static func AppleSDGothicNeoSemiBold(_ size: CGFloat) -> UIFont {
        guard let font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: size) else {
            return UIFont()
        }
        return font
    }
    
    static func AppleSDGothicNeoRegular(_ size: CGFloat) -> UIFont {
        guard let font = UIFont(name: "AppleSDGothicNeo-Regular", size: size) else {
            return UIFont()
        }
        return font
    }
}
