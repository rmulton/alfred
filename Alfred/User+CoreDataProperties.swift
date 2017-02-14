//
//  User+CoreDataProperties.swift
//  Alfred
//
//  Created by rob on 13/02/2017.
//  Copyright © 2017 rmulton. All rights reserved.
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User");
    }

    @NSManaged public var name: String?
    @NSManaged public var toCategories: NSSet?

}

// MARK: Generated accessors for toCategories
extension User {

    @objc(addToCategoriesObject:)
    @NSManaged public func addToToCategories(_ value: Category)

    @objc(removeToCategoriesObject:)
    @NSManaged public func removeFromToCategories(_ value: Category)

    @objc(addToCategories:)
    @NSManaged public func addToToCategories(_ values: NSSet)

    @objc(removeToCategories:)
    @NSManaged public func removeFromToCategories(_ values: NSSet)

}
