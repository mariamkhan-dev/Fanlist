//
//  ArtistStreamViewController.swift
//  ProjectTest
//
//  Created by Mariam Khan on 5/4/21.
//
// CITATIONS:
// 1. https://www.youtube.com/watch?v=sqo844saoC4&t=524s - Helped with API Call

import Foundation
import UIKit

// View Controller to See Top Streamed Songs of Chosen Artist
class ArtistStreamViewController: UITableViewController {

    // MARK: Variables
    let defaults = UserDefaults.standard
    var finalArtistCode = ""
    var listOfTracks = [Track]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: View Loading Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        // Formatting API call URL - Top Songs
        let API_KEY = ""
        let original = UserDefaults.standard.string(forKey: "name")!
        let query = original.replacingOccurrences(of: " ", with: "+")
        let url = "https://ws.audioscrobbler.com/2.0/?method=artist.gettoptracks&artist=\(query)&api_key=\(API_KEY)&limit=10&format=json"
        getData(from: url)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let API_KEY = ""
        let tabbar = tabBarController as! BaseTabBarController
        let original = tabbar.artistName
        let query = original.replacingOccurrences(of: " ", with: "+")
        let url = "https://ws.audioscrobbler.com/2.0/?method=artist.gettoptracks&artist=\(query)&api_key=\(API_KEY)&limit=10&format=json"
        getData(from: url)
        tableView.reloadData()
    }
    
    // MARK: Table View Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfTracks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "streamcell", for: indexPath)
        cell.textLabel?.text = listOfTracks[indexPath.row].name
        let bigNumber = Int(listOfTracks[indexPath.row].playcount)!
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let formattedNumber = numberFormatter.string(from: NSNumber(value:bigNumber))
        cell.detailTextLabel?.text = "Total Streams: \(formattedNumber!)"
         return cell
        }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0

        UIView.animate(
            withDuration: 0.5,
            delay: 0.05 * Double(indexPath.row),
            animations: {
                cell.alpha = 1
        })
    }
    
    // MARK: URLSession shared datatask to make API call
     func getData(from url: String){
        let task = URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: {data, response, error in
            guard let data = data, error == nil else {
                print("something went wrong")
                return
            }
            var result: ArtistGetStreams?
            do {
                result = try JSONDecoder().decode(ArtistGetStreams.self, from: data)
            } catch {
                if (error.localizedDescription == "keyNotFound(CodingKeys(stringValue: 'toptracks', intValue: nil), Swift.DecodingError.Context(codingPath: [], debugDescription: 'No value associated with key CodingKeys(stringValue: \'toptracks\', intValue: nil) (\'toptracks\').', underlyingError: nil))") {
                    print("CodingKeys Not Needed")
                }
            }
            
            guard let json = result  else {return}
            self.listOfTracks = json.toptracks.track
        })
        task.resume()
    }
}
    
    
