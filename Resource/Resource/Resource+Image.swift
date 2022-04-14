//
//  Resource+Image.swift
//  Resource
//
//  Created by 오현식 on 2022/04/14.
//

import UIKit

public extension Resource {
    enum Image {}
}

public extension Resource.Image {
    static var currentLoc: UIImage { .load(name: "current_loc") }
    static var currentBtn: UIImage { .load(name: "current_btn") }
    static var favoriteBlack: UIImage { .load(name: "favorite_black") }
    static var favoriteBlue: UIImage { .load(name: "favorite_blue") }
}

extension UIImage {
    static func load(name: String) -> UIImage {
        guard let image = UIImage(named: name, in: Resource.bundle, compatibleWith: nil) else {
            return UIImage()
        }
        return image
    }
}
