//
//  Category+CoreDataProperties.swift
//  Alfred
//
//  Created by rob on 13/02/2017.
//  Copyright © 2017 rmulton. All rights reserved.
//

import Foundation
import CoreData


extension Category {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category");
    }

    @NSManaged public var descript: String?
    @NSManaged public var image: NSObject?
    @NSManaged public var title: String?
    @NSManaged public var toDetailSections: NSSet?
    @NSManaged public var toUser: User?

}

// MARK: Generated accessors for toDetailSections
extension Category {

    @objc(addToDetailSectionsObject:)
    @NSManaged public func addToToDetailSections(_ value: DetailSection)

    @objc(removeToDetailSectionsObject:)
    @NSManaged public func removeFromToDetailSections(_ value: DetailSection)

    @objc(addToDetailSections:)
    @NSManaged public func addToToDetailSections(_ values: NSSet)

    @objc(removeToDetailSections:)
    @NSManaged public func removeFromToDetailSections(_ values: NSSet)

}
