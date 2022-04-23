//
//  TrackDTO.swift
//  Data
//
//  Created by 오현식 on 2022/04/23.
//

import Domain

public struct TrackDTO {
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
    
    func toEntity() -> Track {
        Track(id: id,
              imageURL: URL(string: imageURLString),
              artist: artist,
              title: title,
              description: description)
    }
}

extension TrackDTO: Equatable {
    public static func == (lhs: TrackDTO, rhs: TrackDTO) -> Bool {
        return
            lhs.id == rhs.id &&
            lhs.imageURLString == rhs.imageURLString &&
            lhs.genres == rhs.genres &&
            lhs.album == rhs.album &&
            lhs.artist == rhs.artist &&
            lhs.title == rhs.title &&
            lhs.description == rhs.description
    }
}
