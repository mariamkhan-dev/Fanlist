//
//  ArtistSearchRequest.swift
//  ProjectTest
//
//  Created by mk on 4/27/21.
//

import Foundation

enum ArtistSearchError:Error {
    case noDataAvailable
    case canNotProcessData
}

struct ArtistSearchRequest {
    let resourceURL:URL
    let API_KEY = "6becf21c411c156446fa0f443891dd5d"
    
    init(artistSearch:String) {
        
        let original = "https://ws.audioscrobbler.com/2.0/?method=artist.search&artist=\(artistSearch)&api_key=\(API_KEY)&format=json"
        let resourceString = original.replacingOccurrences(of: " ", with: "+")
        guard let resourceURL = URL(string: resourceString) else {fatalError()}
        
        self.resourceURL = resourceURL
        
    }
    
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
