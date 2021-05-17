//
//  ArtistStreamsViewController.swift
//  ProjectTest
//
//  Created by mk on 4/27/21.
//

import Foundation
import UIKit

class ArtistSearchViewController: UITableViewController{
    @IBOutlet weak var searchArtistBar: UISearchBar!
    
    var listOfArtists = [Artist]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.navigationItem.title = "Search Results"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchArtistBar.delegate = self
    }
    
    // MARK: Table View Data Source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfArtists.count;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath)
        
        let artist = listOfArtists[indexPath.row]
        cell.textLabel?.text = artist.name
        return cell;
    }
}

extension ArtistSearchViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let searchBarText = searchArtistBar.text else {return}
        let artistSearchRequest = ArtistSearchRequest(artistSearch: searchBarText)
        artistSearchRequest.getArtistSearch { [weak self] result in switch result {
        case .failure(let error):
            print(error)
        case .success(let artists):
            self?.listOfArtists = artists
        }
            
        }
        
    }
}
