//
//  Resource+Color.swift
//  Resource
//
//  Created by 오현식 on 2022/04/14.
//

import UIKit

public extension Resource {
    enum Color {}
}

public extension Resource.Color {
    static var garyDark: UIColor { .load(name: "gary_dark", in: Resource.bundle) }
    static var grayMid: UIColor { .load(name: "gray_mid", in: Resource.bundle) }
    static var grayLight: UIColor { .load(name: "gray_light", in: Resource.bundle) }
}
