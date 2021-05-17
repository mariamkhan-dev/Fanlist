//
//  SettingsViewController.swift
//  ProjectTest
//
//  Created by Mariam Khan on 5/11/21.
//

import Foundation
import UIKit
import CoreData

// View Controller for User to View Their Saved Artist Checklists and Add a New Artist
class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Outlets
    @IBOutlet weak var artistTableView: UITableView!
    
    // MARK: Variables
    var managedObjectContext: NSManagedObjectContext!
    var artistitems = [ArtistItem](){
        didSet {
            DispatchQueue.main.async {
                self.artistTableView.reloadData()
            }
        }
    }
    
    // MARK: View Loading Functions
    override func viewDidLoad() {
      super.viewDidLoad()
        
        // Can't explore other tabs while searching
        self.tabBarController?.tabBar.isHidden = false
        
        // Initial Launch
        if (UserDefaults.standard.string(forKey: "initialLaunch") == nil) {
            UserDefaults.standard.set("Launched", forKey: "initialLaunch")
            artistitems.append(ArtistItem(context: managedObjectContext))
            artistitems[0].name = "Ariana Grande"
        }
      artistTableView.reloadData()
        
      // Retrieving Saved Artists
      let fetchRequest = NSFetchRequest<ArtistItem>()
      let entity = ArtistItem.entity()
      fetchRequest.entity = entity
      do {
        artistitems = try managedObjectContext.fetch(fetchRequest)
      } catch {
        fatalError("Error: \(error)")
      }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Can't explore other tabs while searching
        self.tabBarController?.tabBar.isHidden = false
        
        // Retrieving Saved Artists
        let fetchRequest = NSFetchRequest<ArtistItem>()
        let entity = ArtistItem.entity()
        fetchRequest.entity = entity
        do {
          artistitems = try managedObjectContext.fetch(fetchRequest)
        } catch {
          fatalError("Error: \(error)")
        }
        artistTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Retrieving Saved Artists
        let fetchRequest = NSFetchRequest<ArtistItem>()
        let entity = ArtistItem.entity()
        fetchRequest.entity = entity
          
        do {
          artistitems = try managedObjectContext.fetch(fetchRequest)
        } catch {
          fatalError("Error: \(error)")
        }
        artistTableView.reloadData()
    }
    
    // MARK: Table View Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artistitems.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Recents", for: indexPath)
        let artist = artistitems[indexPath.row]
        cell.textLabel?.text = artist.name
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tabbar = tabBarController as! BaseTabBarController
        tabbar.artistName = artistitems[indexPath.row].name ?? "NO ARTIST"
        UserDefaults.standard.set(artistitems[indexPath.row].name ?? "NO ARTIST", forKey: "name")
        
        // HUD Display - Notifies User That Current Artist Switched
        guard let mainView = navigationController?.parent?.view else { return }
        let hudView = HudView.hud(inView: mainView, animated: true)
        hudView.text = "Artist Switched"
        tableView.deselectRow(at: indexPath, animated: true)
        let delayInSeconds = 1.0
        DispatchQueue.main.asyncAfter(deadline: .now() + delayInSeconds) {
          hudView.hide()
          self.navigationController?.popViewController(animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0
        UIView.animate(
            withDuration: 0.5,
            delay: 0.05 * Double(indexPath.row),
            animations: {
                cell.alpha = 1
        })
    }
    
    func tableView(
      _ tableView: UITableView,
      commit editingStyle: UITableViewCell.EditingStyle,
      forRowAt indexPath: IndexPath
    ) {
      if editingStyle == .delete {
        let artistitem = artistitems[indexPath.row]
        artistitems.remove(at: indexPath.row)
        managedObjectContext.delete(artistitem)
        do {
          try managedObjectContext.save()
        } catch {
            fatalError("Error: \(error)")
        }
      }
    }

    // MARK: Prepare for Segue - Search
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if segue.identifier == "startSearch" {
        let controller = segue.destination as! ArtistSearchViewController
        controller.managedObjectContext = managedObjectContext
      }
    }
}
