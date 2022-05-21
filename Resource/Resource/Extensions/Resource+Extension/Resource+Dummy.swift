//
//  Resource+Dummy.swift
//  Resource
//
//  Created by 오현식 on 2022/04/24.
//

import Common
import UIKit

extension Resource {
    public final class Dummy {
        enum ID: String {
            case zone
            
            var stringValue: String {
                return self.rawValue.firstCharCapitalized
            }
        }
        
        let data: Data
        
        init?(id: ID) {
            guard let asset = NSDataAsset.init(name: id.stringValue, bundle: Resource.bundle) else {
                return nil
            }
            self.data = asset.data
        }
    }
}

extension Resource.Dummy {
    typealias Dummy = Resource.Dummy
    
    public static var zone: Data? { Dummy(id: .zone)?.data }
}
