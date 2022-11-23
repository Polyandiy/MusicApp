//
//  SearchTrackModel.swift
//  MusicApp
//
//  Created by Поляндий on 23.11.2022.
//

import Foundation

struct SearchResponseModel: Decodable {
    var resultCount: Int
    var results: [Track]
}

struct Track: Decodable {
    var trackName: String
    var collectionName: String?
    var artistName: String
    var artworkUrl100: String?
}