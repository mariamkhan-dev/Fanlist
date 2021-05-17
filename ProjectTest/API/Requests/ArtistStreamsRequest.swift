//
//  ArtistStreamsRequest.swift
//  ProjectTest
//
//  Created by Mariam Khan on 5/4/21.
//

import Foundation

// Error Cases
enum ArtistStreamsError:Error {
    case noDataAvailable
    case canNotProcessData
}

//  Formatting API call URL - Top Tracks
struct ArtistStreamsRequest {
    let resourceURL:URL
    let API_KEY = ""
    
    init(artistStreams:String) {
        
    let original = "https://ws.audioscrobbler.com/2.0/?method=artist.getTopTracks&mbid=\(artistStreams)&api_key=\(API_KEY)&format=json"
        let resourceString = original.replacingOccurrences(of: " ", with: "+")
        guard let resourceURL = URL(string: resourceString) else {fatalError()}
        
        self.resourceURL = resourceURL
        
    }
    
// URLSession shared datatask to make API call
    func getArtistStreams (completion: @escaping(Result<[Track], ArtistStreamsError>) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: resourceURL) {data, _, _ in
            guard let jsonData = data else {
                completion(.failure(.noDataAvailable))
                return
            }
            do {
                let decoder = JSONDecoder()
                let artistTracks = try decoder.decode(ArtistGetStreams.self, from: jsonData)
                let artistsTracks = artistTracks.toptracks.track
                completion(.success(artistsTracks))
                
            } catch {
                completion(.failure(.canNotProcessData))
            }
        }
        dataTask.resume()
    }
}
