//
//  DetailSection+CoreDataProperties.swift
//  Alfred
//
//  Created by rob on 13/02/2017.
//  Copyright © 2017 rmulton. All rights reserved.
//

import Foundation
import CoreData


extension DetailSection {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DetailSection> {
        return NSFetchRequest<DetailSection>(entityName: "DetailSection");
    }

    @NSManaged public var title: String?
    @NSManaged public var toCategory: Category?
    @NSManaged public var toDetails: NSSet?

}

// MARK: Generated accessors for toDetails
extension DetailSection {

    @objc(addToDetailsObject:)
    @NSManaged public func addToToDetails(_ value: Detail)

    @objc(removeToDetailsObject:)
    @NSManaged public func removeFromToDetails(_ value: Detail)

    @objc(addToDetails:)
    @NSManaged public func addToToDetails(_ values: NSSet)

    @objc(removeToDetails:)
    @NSManaged public func removeFromToDetails(_ values: NSSet)

}
