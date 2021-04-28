//
//  ChecklistDetailsViewController.swift
//  ProjectTest
//
//  Created by mk on 4/11/21.
//

import UIKit
import CoreData

class ChecklistDetailsViewController: UIViewController {
    
    @IBOutlet weak var descriptionText: UITextView!
    var managedObjectContext: NSManagedObjectContext!
    @IBOutlet weak var ActivityDetails: UITextView!
    var descriptionTexts = ""
    var checklistToEdit: ChecklistItem? {
      didSet {
        if let checklist = checklistToEdit {
            descriptionTexts = checklist.checklistTitle ?? "No Description"
        }
      }
    }


    override func viewDidLoad() {
        
        if let checklistitem = checklistToEdit {
            title = "Edit Fan Activity"
          }
        
      super.viewDidLoad()
        
        descriptionText.text = descriptionTexts
    }
    
    @IBAction func done() {
        let checklistitem = ChecklistItem(context: managedObjectContext)
      checklistitem.checklistTitle = descriptionText.text
        do {
          try managedObjectContext.save()
        } catch {
          fatalError("Error: \(error)")
        }

      navigationController?.popViewController(animated: true)
        
    }
    
}
