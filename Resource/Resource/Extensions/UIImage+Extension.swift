//
//  UIImage+Extension.swift
//  Resource
//
//  Created by 오현식 on 2022/04/15.
//

import UIKit

extension UIImage {
    static func load(name: String, in bundle: Bundle) -> UIImage {
        guard let image = UIImage(named: name, in: bundle, compatibleWith: nil) else {
            return UIImage()
        }
        return image
    }
}
