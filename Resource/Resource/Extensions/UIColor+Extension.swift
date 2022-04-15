//
//  UIColor+Extension.swift
//  Resource
//
//  Created by 오현식 on 2022/04/15.
//

import UIKit

extension UIColor {
    static func load(name: String, in bundle: Bundle) -> UIColor {
        guard let color = UIColor(named: name, in: bundle, compatibleWith: nil) else {
            return UIColor()
        }
        return color
    }
}
