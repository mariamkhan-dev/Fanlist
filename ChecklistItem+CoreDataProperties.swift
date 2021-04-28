//
//  ChecklistItem+CoreDataProperties.swift
//  ProjectTest
//
//  Created by m khan on 4/13/21.
//
//

import Foundation
import CoreData


extension ChecklistItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ChecklistItem> {
        return NSFetchRequest<ChecklistItem>(entityName: "ChecklistItem")
    }

    @NSManaged public var checklistTitle: String?

}

extension ChecklistItem : Identifiable {

}
