//
//  Item.swift
//  Todoey
//
//  Created by Ram Wadher on 12/02/2019.
//  Copyright © 2019 Ram Wadher. All rights reserved.
//

import Foundation

class Item: Codable {
    
    //in order to use encodable then all propertied must be standard and not custom .... i.e. enums
    var title: String = ""
    var done: Bool = false
}
