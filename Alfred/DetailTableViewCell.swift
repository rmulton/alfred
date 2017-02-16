//
//  DetailsTableViewCell.swift
//  Alfred
//
//  Created by rob on 10/02/2017.
//  Copyright © 2017 rmulton. All rights reserved.
//

import UIKit

class DetailTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var descript: UILabel!
    @IBOutlet weak var source: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func updateUI(detail: Detail){
        title.text = detail.title
        descript.text = detail.descript
        source.text = detail.source
        
        title.sizeToFit()
        descript.sizeToFit()
        source.sizeToFit()
        
        self.sizeToFit()
    }
}
