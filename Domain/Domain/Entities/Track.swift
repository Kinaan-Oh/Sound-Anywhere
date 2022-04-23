//
//  Track.swift
//  Domain
//
//  Created by 오현식 on 2022/04/23.
//

public struct Track {
    public let id: String
    public let imageURL: URL?
    public let artist: String
    public let title: String
    public let description: String
    
    public init(id: String,
         imageURL: URL?,
         artist: String,
         title: String,
         description: String
    ) {
        self.id = id
        self.imageURL = imageURL
        self.artist = artist
        self.title = title
        self.description = description
    }
}
