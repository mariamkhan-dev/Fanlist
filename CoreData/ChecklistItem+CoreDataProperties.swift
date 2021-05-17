//
//  ChecklistItem+CoreDataProperties.swift
//  ProjectTest
//
//  Created by Mariam Khan on 5/11/21.
//
//

import Foundation
import CoreData


extension ChecklistItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ChecklistItem> {
        return NSFetchRequest<ChecklistItem>(entityName: "ChecklistItem")
    }

    @NSManaged public var checklistTitle: String?
    @NSManaged public var artist: ArtistItem?

}

extension ChecklistItem : Identifiable {

}
