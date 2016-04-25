//
//  ItemType+CoreDataProperties.swift
//  PlannedBuyersHood
//
//  Created by Jesse Tellez on 4/25/16.
//  Copyright © 2016 Jesse Tellez. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension ItemType {

    @NSManaged var type: String?
    @NSManaged var item: NSSet?

}
