//
//  ChecklistViewController.swift
//  ProjectTest
//
//  Created by Mariam Khan on 4/11/21.
//

import Foundation
import UIKit
import CoreData

// View Controller for Seeing List of Fan Things To Do
class ChecklistViewController: UITableViewController{
    
    // MARK: Variables
    var managedObjectContext: NSManagedObjectContext!
    var checklistCollection = [ChecklistItem]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: Outlets
    // Change Background Color Button
    @IBAction func setColor(_ sender: Any) {
        let selectionVC = storyboard?.instantiateViewController(identifier: "ChangeChecklistColor") as! ChangeChecklistColorViewController
        selectionVC.selectionDelegate = self
        present(selectionVC, animated: true, completion: nil)
    }

    // Fetched Results Controller
    lazy var fetchedResultsController: NSFetchedResultsController<ChecklistItem> = {

      let fetchRequest = NSFetchRequest<ChecklistItem>()

      let entity = ChecklistItem.entity()
      fetchRequest.entity = entity
      let pred = NSPredicate(format: "artist.name == '\(UserDefaults.standard.string(forKey: "name")!)'")
      fetchRequest.predicate = pred

      let sortDescriptor = NSSortDescriptor(
        key: "checklistTitle",
        ascending: false)
      fetchRequest.sortDescriptors = [sortDescriptor]

      fetchRequest.fetchBatchSize = 20

      let fetchedResultsController = NSFetchedResultsController(
        fetchRequest: fetchRequest,
        managedObjectContext: self.managedObjectContext,
        sectionNameKeyPath: nil,
        cacheName: "ChecklistItem")
        
        
      fetchedResultsController.delegate = self
      return fetchedResultsController
    }()
    
    func performFetch() {
      do {
        try fetchedResultsController.performFetch()
      } catch {
        fatalError("Error: \(error)")
      }
    }
    
    deinit {
      fetchedResultsController.delegate = nil
    }
    
    
    // MARK: View Loading Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = false
        
        if (UserDefaults.standard.string(forKey: "name") == nil) {
            UserDefaults.standard.set("Ariana Grande", forKey: "name")
            let alert = UIAlertController(title: "Welcome to Fanlist!", message: "Thank you for downloading our app! We have your artist set to Ariana Grande for now, but navigate to the Settings tab to change to your favorite artist! Switch up those positions!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK!", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        navigationItem.leftBarButtonItem = editButtonItem
        
        let fetchRequest = NSFetchRequest<ChecklistItem>()
        let entity = ChecklistItem.entity()
        fetchRequest.entity = entity
        let pred = NSPredicate(format: "artist.name == '\(UserDefaults.standard.string(forKey: "name")!)'")
        fetchRequest.predicate = pred
        do {
            checklistCollection = try managedObjectContext.fetch(fetchRequest)
        } catch {
          fatalError("Error: \(error)")
        }
        
        performFetch()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
        if (UserDefaults.standard.string(forKey: "background_color_hex") == nil) {
            tableView.backgroundColor = .white
        } else {
            UserDefaults.standard.string(forKey: "background_color_hex")
            tableView.backgroundColor = UIColor(rgb: Int(UserDefaults.standard.string(forKey: "background_color_hex") ?? "FFFFFF") ?? 0)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        let fetchRequest = NSFetchRequest<ChecklistItem>()
        let entity = ChecklistItem.entity()
        fetchRequest.entity = entity
        let pred = NSPredicate(format: "artist.name == '\(UserDefaults.standard.string(forKey: "name")!)'")
        fetchRequest.predicate = pred
        do {
            checklistCollection = try managedObjectContext.fetch(fetchRequest)
        } catch {
          fatalError("Error: \(error)")
        }
        
        performFetch()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    
    // MARK: Table View Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checklistCollection.count
    }
    
    
    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
      ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
          withIdentifier: "ChecklistItemCell",
          for: indexPath) as! ChecklistItemCell
        let checklistitem = checklistCollection[indexPath.row]
       cell.configure(for: checklistitem)
        cell.descriptionLabel.text = checklistCollection[indexPath.row].checklistTitle
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
    
    override func tableView(
      _ tableView: UITableView,
      commit editingStyle: UITableViewCell.EditingStyle,
      forRowAt indexPath: IndexPath
    ) {
      if editingStyle == .delete {
        let checklistitem = checklistCollection[indexPath.row]
        checklistCollection.remove(at: indexPath.row)
        managedObjectContext.delete(checklistitem)
        tableView.deleteRows(at: [indexPath], with: .fade)
        do {
          try managedObjectContext.save()
        } catch {
            fatalError("Error: \(error)")
        }
      }
    }
    
    // MARK: Prepare for Segue - Adding Checklist Item
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if segue.identifier == "AddItem" {
        let controller = segue.destination as! ChecklistDetailsViewController
        controller.managedObjectContext = managedObjectContext
      }
    }
    
}

// MARK: - NSFetchedResultsController Delegate Extension
extension ChecklistViewController: NSFetchedResultsControllerDelegate {
  func controllerWillChangeContent(
    _ controller: NSFetchedResultsController<NSFetchRequestResult>
  ) {
    print("*** controllerWillChangeContent")
    tableView.beginUpdates()
  }

  func controller(
    _ controller: NSFetchedResultsController<NSFetchRequestResult>,
    didChange anObject: Any,
    at indexPath: IndexPath?,
    for type: NSFetchedResultsChangeType,
    newIndexPath: IndexPath?
  ) {
    switch type {
    case .insert:
      print("*** NSFetchedResultsChangeInsert (object)")
        tableView.insertRows(at: [newIndexPath!], with: .fade)
        let fetchRequest = NSFetchRequest<ChecklistItem>()
        let entity = ChecklistItem.entity()
        fetchRequest.entity = entity
        let pred = NSPredicate(format: "artist.name == '\(UserDefaults.standard.string(forKey: "name")!)'")
        fetchRequest.predicate = pred
        do {
            checklistCollection = try managedObjectContext.fetch(fetchRequest)
        } catch {
          fatalError("Error: \(error)")
        }

            case .delete:
              print("*** NSFetchedResultsChangeDelete (object)")
                let fetchRequest = NSFetchRequest<ChecklistItem>()
                let entity = ChecklistItem.entity()
                fetchRequest.entity = entity
                let pred = NSPredicate(format: "artist.name == '\(UserDefaults.standard.string(forKey: "name")!)'")
                fetchRequest.predicate = pred
                do {
                    checklistCollection = try managedObjectContext.fetch(fetchRequest)
                } catch {
                  fatalError("Error: \(error)")
                }

            case .update:
              print("*** NSFetchedResultsChangeUpdate (object)")
              if let cell = tableView.cellForRow(
                at: indexPath!) as? ChecklistItemCell {
                let checklist = controller.object(
                  at: indexPath!) as! ChecklistItem
                cell.configure(for: checklist)
              }

            case .move:
              print("*** NSFetchedResultsChangeMove (object)")
                let fetchRequest = NSFetchRequest<ChecklistItem>()
                let entity = ChecklistItem.entity()
                fetchRequest.entity = entity
                let pred = NSPredicate(format: "artist.name == '\(UserDefaults.standard.string(forKey: "name")!)'")
                fetchRequest.predicate = pred
                do {
                    checklistCollection = try managedObjectContext.fetch(fetchRequest)
                } catch {
                  fatalError("Error: \(error)")
                }
              
            @unknown default:
                print("*** NSFetchedResults unknown type")
                    }
                  }

                  func controller(
                    _ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType
                  ) {
                    switch type {
                    case .insert:
                      print("*** NSFetchedResultsChangeInsert (section)")
                      tableView.insertSections(
                        IndexSet(integer: sectionIndex), with: .fade)
                    case .delete:
                      print("*** NSFetchedResultsChangeDelete (section)")
                      tableView.deleteSections(
                        IndexSet(integer: sectionIndex), with: .fade)
                    case .update:
                      print("*** NSFetchedResultsChangeUpdate (section)")
                        case .move:
                              print("*** NSFetchedResultsChangeMove (section)")
                            @unknown default:
                              print("*** NSFetchedResults unknown type")
                            }
                          }

                          func controllerDidChangeContent(
                            _ controller: NSFetchedResultsController<NSFetchRequestResult>
                          ) {
                            print("*** controllerDidChangeContent")
                            tableView.endUpdates()
                          }
                        }

// MARK: Delegate Protocol Extension
extension ChecklistViewController: colorSelectionDelegate {
    func didTapColor(color: UIColor) {
        tableView.backgroundColor = color
    }
}

