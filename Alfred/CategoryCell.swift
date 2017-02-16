//
//  CategoryCell.swift
//  Alfred
//
//  Created by rob on 07/02/2017.
//  Copyright © 2017 rmulton. All rights reserved.
//

import UIKit

class CategoryCell: UITableViewCell {
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var details: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func updateUI(category: Category) {
        details.text = category.descript
        title.text = category.title
        img.image = category.image as! UIImage?
    }
 
}
