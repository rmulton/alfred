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
        self.img.clipsToBounds = false
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateUI(category: Category) {
        details.text = category.descript
        title.text = category.title
        img.image = category.image as! UIImage?
        
    }
 
}
