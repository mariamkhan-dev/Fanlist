//
//  ChecklistDetailsViewController.swift
//  ProjectTest
//
//  Created by Mariam Khan on 4/11/21.
//

import UIKit
import CoreData
import AVFoundation

// View Controller to Add New Checklist Item to Fanlist
class ChecklistDetailsViewController: UIViewController {
    
    // MARK: Variables
    var managedObjectContext: NSManagedObjectContext!
    var descriptionTexts = ""
    var checklistToEdit: ChecklistItem? {
      didSet {
        if let checklist = checklistToEdit {
            descriptionTexts = checklist.checklistTitle ?? "No Description"
        }
      }
    }
    let defaults = UserDefaults.standard
    var artistCollection = [ArtistItem]()
    var checklistCollection = [ChecklistItem]()
    var audioPlayer: AVAudioPlayer?
    
    // MARK: Outlets
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var ActivityDetails: UITextView!
    
    // Done Button - Saving Checklist Item
    @IBAction func done() {
        // Play Sound
        let pathToSound = Bundle.main.path(forResource: "button sound effect", ofType: "mp3")!
        let url = URL(fileURLWithPath: pathToSound)
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print(error)
        }
        // Adding Checklist Item to Appropriate Artist in Core Data
        let checklistitem = ChecklistItem(context: managedObjectContext)
        checklistitem.checklistTitle = descriptionText.text
        let fetchRequest = NSFetchRequest<ArtistItem>()
        let entity = ArtistItem.entity()
        fetchRequest.entity = entity
        let pred = NSPredicate(format: "name == '\(UserDefaults.standard.string(forKey: "name")!)'")
        fetchRequest.predicate = pred
        do {
          artistCollection = try managedObjectContext.fetch(fetchRequest)
            if (artistCollection.isEmpty == false) {
                artistCollection[0].addToChecklists(checklistitem)
                do {
                  try managedObjectContext.save()
                } catch {
                  fatalError("FATAL Error: \(error)")
                }
                
            }
        } catch {
          fatalError("Error: \(error)")
        }
      navigationController?.popViewController(animated: true)
    
    }
    
    // MARK: View Loading Functions
    override func viewDidLoad() {
      super.viewDidLoad()
        descriptionText.text = descriptionTexts
        self.tabBarController?.tabBar.isHidden = true
    }
    
}

