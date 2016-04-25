//
//  ListCell.swift
//  PlannedBuyersHood
//
//  Created by Jesse Tellez on 4/19/16.
//  Copyright © 2016 Jesse Tellez. All rights reserved.
//

import UIKit

class ListCell: UITableViewCell {

    @IBOutlet weak var tumbnailImage: UIImageView!
    @IBOutlet weak var titleOfItem: UILabel!
    @IBOutlet weak var priceOfItem: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    
    func configCell(item: Item) {
        
        titleOfItem.text = item.title
        priceOfItem.text = "$\(item.price!)"
        detailsLabel.text = item.details
        
        if let image = item.image?.getItemImage() {
            tumbnailImage.image = image
        }
    }
    
}
