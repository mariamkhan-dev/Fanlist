//
//  ChecklistViewController.swift
//  ProjectTest
//
//  Created by mk on 4/11/21.
//

import Foundation
import UIKit
import CoreData

class ChecklistViewController: UITableViewController{
    
    var managedObjectContext: NSManagedObjectContext!
  //  var checklistItems = [ChecklistItem]()
    lazy var fetchedResultsController: NSFetchedResultsController<ChecklistItem> = {
      let fetchRequest = NSFetchRequest<ChecklistItem>()

      let entity = ChecklistItem.entity()
      fetchRequest.entity = entity

      let sortDescriptor = NSSortDescriptor(
        key: "checklistTitle",
        ascending: true)
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let fetchRequest = NSFetchRequest<ChecklistItem>()
//        let entity = ChecklistItem.entity()
//        fetchRequest.entity = entity
//        let sortDescriptor = NSSortDescriptor(
//          key: "checklistTitle",
//          ascending: true)
//        fetchRequest.sortDescriptors = [sortDescriptor]
//        do {
//          checklistItems = try managedObjectContext.fetch(fetchRequest)
//        } catch {
//            fatalError("Error: \(error)")
//        }
        navigationItem.leftBarButtonItem = editButtonItem
        performFetch()
    }
    
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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section]
          return sectionInfo.numberOfObjects
    }
    
    
    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
      ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
          withIdentifier: "ChecklistItemCell",
          for: indexPath) as! ChecklistItemCell
        let checklistitem = fetchedResultsController.object(at: indexPath)
        cell.configure(for: checklistitem)
            return cell
          }
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let checklistItem = checklistItems[indexPath.row]
//
//    }
    
//    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        if let cell = tableView.cellForRow(at: indexPath) {
//            if (cell.accessoryType == .checkmark) {
//                cell.accessoryType = .none
//            } else {
//                cell.accessoryType = .checkmark
//                tableView.deselectRow(at: indexPath, animated: true)
//            }
            //tableView.deselectRow(at: indexPath, animated: true)
//        }
//
//    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if segue.identifier == "AddItem" {
        let controller = segue.destination as! ChecklistDetailsViewController
        controller.managedObjectContext = managedObjectContext
      }
        if segue.identifier == "EditChecklistItem" {
          let controller = segue.destination  as! ChecklistDetailsViewController
          controller.managedObjectContext = managedObjectContext

          if let indexPath = tableView.indexPath(
            for: sender as! UITableViewCell) {
            let checklistitem = fetchedResultsController.object(at: indexPath)
            controller.checklistToEdit = checklistitem
          }
            
            
        }
    }

    override func tableView(
      _ tableView: UITableView,
      commit editingStyle: UITableViewCell.EditingStyle,
      forRowAt indexPath: IndexPath
    ) {
      if editingStyle == .delete {
        let checklistitem = fetchedResultsController.object(
          at: indexPath)
        managedObjectContext.delete(checklistitem)
        do {
          try managedObjectContext.save()
        } catch {
            fatalError("Error: \(error)")
        }
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

            case .delete:
              print("*** NSFetchedResultsChangeDelete (object)")
              tableView.deleteRows(at: [indexPath!], with: .fade)

            case .update:
              print("*** NSFetchedResultsChangeUpdate (object)")
              if let cell = tableView.cellForRow(
                at: indexPath!) as? ChecklistItemCell {
                let location = controller.object(
                  at: indexPath!) as! ChecklistItem
                cell.configure(for: location)
              }

            case .move:
              print("*** NSFetchedResultsChangeMove (object)")
              tableView.deleteRows(at: [indexPath!], with: .fade)
              tableView.insertRows(at: [newIndexPath!], with: .fade)
              
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
