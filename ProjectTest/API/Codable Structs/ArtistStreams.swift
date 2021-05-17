//
//  ArtistStreams.swift
//  ProjectTest
//
//  Created by Mariam Khan on 5/4/21.
//
// 1. https://app.quicktype.io/ - Helped Create Structs

import Foundation

// Codable Struct for Artist Top Streamed Songs API Call
// MARK: - ArtistGetStreams
struct ArtistGetStreams: Codable {
    let toptracks: Toptracks
}

// MARK: - Toptracks
struct Toptracks: Codable {
    let track: [Track]
    let attr: ToptracksAttr?
}

// MARK: - ToptracksAttr
struct ToptracksAttr: Codable {
    let page, perPage, totalPages, total: String
}


// MARK: - Track
struct Track: Codable {
    let name, playcount, listeners: String
    let url: String
    let streamable: String
    let artist: ArtistClass
    let attr: TrackAttr?
    let mbid: String?
}

// MARK: - ArtistClass
struct ArtistClass: Codable {
    let mbid: String?
    let url: String
}

// MARK: - TrackAttr
struct TrackAttr: Codable {
    let rank: String
}


