//
//  Zone.swift
//  Domain
//
//  Created by 오현식 on 2022/04/23.
//

import CoreLocation

import Common

public struct Zone {
    public let id: String
    public let name: String
    public let trackList: [Track]
    public let coordinate: CLLocationCoordinate2D
    
    public init(id: String,
         name: String,
         trackList: [Track],
         coordinate: CLLocationCoordinate2D
    ) {
        self.id = id
        self.name = name
        self.trackList = trackList
        self.coordinate = coordinate
    }
}

extension Zone: Equatable {
    public static func == (lhs: Zone, rhs: Zone) -> Bool {
        return
            lhs.id == rhs.id &&
            lhs.name == rhs.name &&
            lhs.trackList == rhs.trackList &&
            lhs.coordinate == rhs.coordinate
    }
}
