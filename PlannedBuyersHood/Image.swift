//
//  Image.swift
//  PlannedBuyersHood
//
//  Created by Jesse Tellez on 4/17/16.
//  Copyright © 2016 Jesse Tellez. All rights reserved.
//

import Foundation
import CoreData
import UIKit


class Image: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    
    func setItemImage(img: UIImage) {
        self.image = img
    }
    
    func getItemImage() -> UIImage {
        if let img = self.image as? UIImage {
            return img
        }
        
        return UIImage(named: "Facial-Recognition")!
    }

}
