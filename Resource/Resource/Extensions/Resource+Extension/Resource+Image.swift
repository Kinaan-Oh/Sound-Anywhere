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
    static var currentLoc: UIImage { .load(name: "current_loc", in: Resource.bundle) }
    static var currentBtn: UIImage { .load(name: "current_btn", in: Resource.bundle) }
    static var favoriteBlack: UIImage { .load(name: "favorite_black", in: Resource.bundle) }
    static var favoriteBlue: UIImage { .load(name: "favorite_blue", in: Resource.bundle) }
}
