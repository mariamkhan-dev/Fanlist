//
//  ArtistItem+CoreDataProperties.swift
//  ProjectTest
//
//  Created by Mariam Khan on 5/11/21.
//
//

import Foundation
import CoreData


extension ArtistItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ArtistItem> {
        return NSFetchRequest<ArtistItem>(entityName: "ArtistItem")
    }

    @NSManaged public var name: String?
    @NSManaged public var checklists: NSSet?

}

// MARK: Generated accessors for checklists
extension ArtistItem {

    @objc(addChecklistsObject:)
    @NSManaged public func addToChecklists(_ value: ChecklistItem)

    @objc(removeChecklistsObject:)
    @NSManaged public func removeFromChecklists(_ value: ChecklistItem)

    @objc(addChecklists:)
    @NSManaged public func addToChecklists(_ values: NSSet)

    @objc(removeChecklists:)
    @NSManaged public func removeFromChecklists(_ values: NSSet)

}

extension ArtistItem : Identifiable {

}
