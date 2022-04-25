//
//  Resource+Dummy.swift
//  Resource
//
//  Created by 오현식 on 2022/04/24.
//

import Common

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
            guard let path = Resource.bundle.path(forResource: id.stringValue, ofType: "json"),
                  let data = try? String(contentsOfFile: path).data(using: .utf8)
            else { return nil }
            self.data = data
        }
    }
}

extension Resource.Dummy {
    typealias Dummy = Resource.Dummy
    
    public static var zone: Data? { Dummy(id: .zone)?.data }
}
