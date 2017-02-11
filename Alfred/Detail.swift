//
//  Details.swift
//  Alfred
//
//  Created by rob on 10/02/2017.
//  Copyright © 2017 rmulton. All rights reserved.
//

import Foundation

class Detail{
    
    var _source: String!
    var _descript: String!
    
    var source: String!{
        return _source
    }
    
    var descript: String!{
        return _descript
    }
    
    init(source: String?, descript: String?) {
        
        if source != nil{
            self._source = source!
        }
        else{
            self._source = ""
        }
        
        if descript != nil{
            self._descript = descript!
        }
        else{
            self._descript = ""
        }
    }
    
}
