//
//  ZoneDTO.swift
//  Data
//
//  Created by 오현식 on 2022/04/23.
//

import CoreLocation

import Domain

public struct ZoneDTO {
    let id: String
    let name: String
    let trackList: [TrackDTO]
    let coordinate: CLLocationCoordinate2D
    
    init(id: String,
         name: String,
         trackList: [TrackDTO],
         coordinate: CLLocationCoordinate2D
    ) {
        self.id = id
        self.name = name
        self.trackList = trackList
        self.coordinate = coordinate
    }
    
    func toEntity() -> Zone {
        Zone(id: id,
             name: name,
             trackList: trackList.map { $0.toEntity() },
             coordinate: coordinate)
    }
}

extension ZoneDTO: Equatable {
    public static func == (lhs: ZoneDTO, rhs: ZoneDTO) -> Bool {
        return
            lhs.id == rhs.id &&
            lhs.name == rhs.name &&
            lhs.trackList == rhs.trackList &&
            lhs.coordinate == rhs.coordinate
    }
}
