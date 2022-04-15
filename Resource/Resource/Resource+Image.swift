//
//  Resource+Image.swift
//  Resource
//
//  Created by 오현식 on 2022/04/14.
//

import UIKit
import Common

public extension Resource {
    enum Image {}
}

public extension Resource.Image {
    static var currentLoc: UIImage { .load(name: "current_loc", in: Resource.bundle) }
    static var currentBtn: UIImage { .load(name: "current_btn", in: Resource.bundle) }
    static var favoriteBlack: UIImage { .load(name: "favorite_black", in: Resource.bundle) }
    static var favoriteBlue: UIImage { .load(name: "favorite_blue", in: Resource.bundle) }
}

extension UIImage {
    static func load(name: String, in bundle: Bundle) -> UIImage {
        guard let image = UIImage(named: name, in: bundle, compatibleWith: nil) else {
            return UIImage()
        }
        return image
    }
}
