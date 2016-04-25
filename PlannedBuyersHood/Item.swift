//
//  Item.swift
//  PlannedBuyersHood
//
//  Created by Jesse Tellez on 4/17/16.
//  Copyright © 2016 Jesse Tellez. All rights reserved.
//

import Foundation
import CoreData


class Item: NSManagedObject {
    
    override func awakeFromInsert() {
        //any time object is inserted into managed object context
        
        super.awakeFromInsert()
        self.created = NSDate()
        
    }

// Insert code here to add functionality to your managed object subclass

}
