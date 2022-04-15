//
//  CALayer+Extension.swift
//  Common
//
//  Created by 오현식 on 2022/04/15.
//

// reference: https://stackoverflow.com/questions/39627724/uiview-shadow-using-user-defined-runtime-attributes

import UIKit
import QuartzCore

extension CALayer {
    var shadowUIColor: UIColor {
        get {
            guard let shadowColor = self.shadowColor else {
                return UIColor()
            }
            return UIColor(cgColor: shadowColor)
        }
        set {
            self.shadowColor = newValue.cgColor
        }
    }
}
