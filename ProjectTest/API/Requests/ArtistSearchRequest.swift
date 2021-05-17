//
//  ArtistSearchRequest.swift
//  ProjectTest
//
//  Created by Mariam Khan on 4/27/21.
//

// CITATIONS
// 1. https://www.youtube.com/watch?v=tdxKIPpPDAI - Used model to implement search using API

import Foundation

// Error Cases
enum ArtistSearchError:Error {
    case noDataAvailable
    case canNotProcessData
}

// Formatting API call URL - Search 
struct ArtistSearchRequest {
    let resourceURL:URL
    let API_KEY = ""
    
    init(artistSearch:String) {
        
        let original = "https://ws.audioscrobbler.com/2.0/?method=artist.search&artist=\(artistSearch)&api_key=\(API_KEY)&format=json"
        let resourceString = original.replacingOccurrences(of: " ", with: "+")
        guard let resourceURL = URL(string: resourceString) else {fatalError()}
        
        self.resourceURL = resourceURL
        
    }
    
// URLSession shared datatask to make API call
    func getArtistSearch (completion: @escaping(Result<[Artist], ArtistSearchError>) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: resourceURL) {data, _, _ in
            guard let jsonData = data else {
                completion(.failure(.noDataAvailable))
                return
            }
            do {
                let decoder = JSONDecoder()
                let artistsResponse = try decoder.decode(Welcome.self, from: jsonData)
                let artistDetails = artistsResponse.results.artistmatches.artist
                completion(.success(artistDetails))
                
            } catch {
                completion(.failure(.canNotProcessData))
            }
        }
        dataTask.resume()
    }
}
