//
//  Detail+CoreDataProperties.swift
//  Alfred
//
//  Created by rob on 13/02/2017.
//  Copyright © 2017 rmulton. All rights reserved.
//

import Foundation
import CoreData


extension Detail {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Detail> {
        return NSFetchRequest<Detail>(entityName: "Detail");
    }

    @NSManaged public var descript: String?
    @NSManaged public var source: String?
    @NSManaged public var title: String?
    @NSManaged public var toDetailSection: DetailSection?

}
