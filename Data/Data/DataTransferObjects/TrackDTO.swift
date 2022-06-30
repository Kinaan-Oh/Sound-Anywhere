//
//  TrackDTO.swift
//  Data
//
//  Created by 오현식 on 2022/04/23.
//

import Domain

public struct TrackDTO: Codable {
    let id: String
    let imageURLString: String
    let genres: [String]
    let album: String
    let artist: String
    let title: String
    let description: String
    
    init(id: String,
         imageURLString: String,
         genres: [String],
         album: String,
         artist: String,
         title: String,
         description: String
    ) {
        self.id = id
        self.imageURLString = imageURLString
        self.genres = genres
        self.album = album
        self.artist = artist
        self.title = title
        self.description = description
    }
    
    init(track: Track) {
        self.id = track.id
        self.imageURLString = ""
        self.genres = []
        self.album = ""
        self.artist = track.artist
        self.title = track.title
        self.description = track.description
    }
    
    func toEntity() -> Track {
        Track(id: id,
              imageURL: URL(string: imageURLString),
              artist: artist,
              title: title,
              description: description)
    }
}

extension TrackDTO: Equatable {}
