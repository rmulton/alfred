//
//  File.swift
//  Alfred
//
//  Created by rob on 07/02/2017.
//  Copyright © 2017 rmulton. All rights reserved.
//

import Foundation

class Category {
    
    private var _title: String!
    private var _description: String!
    private var _imageURL: String!
    
    var title: String {
        return _title
    }
    
    var description: String{
        return _description
    }
    
    var imageURL: String{
        return _imageURL
    }
    
    init(title: String, description: String, imageURL: String) {
        
        _title = title
        _description = description
        _imageURL = imageURL
        
    }
}
