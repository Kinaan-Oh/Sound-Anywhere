//
//  ZoneDTO.swift
//  Data
//
//  Created by 오현식 on 2022/04/23.
//

import CoreLocation

import Domain

public struct ZoneDTO: Codable {
    let id: String
    let name: String
    let latitude: CLLocationDegrees
    let longitude: CLLocationDegrees
    let trackList: [TrackDTO]
    
    init(id: String,
         name: String,
         latitude: CLLocationDegrees,
         longitude: CLLocationDegrees,
         trackList: [TrackDTO]
    ) {
        self.id = id
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.trackList = trackList
    }
    
    init(zone: Zone) {
        self.id = zone.id
        self.name = zone.name
        self.latitude = zone.coordinate.latitude
        self.longitude = zone.coordinate.longitude
        self.trackList = zone.trackList.map { TrackDTO(track: $0) }
    }
    
    func toEntity() -> Zone {
        Zone(id: id,
             name: name,
             trackList: trackList.map { $0.toEntity() },
             coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
    }
}

extension ZoneDTO: Equatable {
    public static func == (lhs: ZoneDTO, rhs: ZoneDTO) -> Bool {
        return
            lhs.id == rhs.id &&
            lhs.name == rhs.name &&
            lhs.trackList == rhs.trackList &&
            lhs.latitude == rhs.latitude &&
            lhs.longitude == rhs.longitude
    }
}
