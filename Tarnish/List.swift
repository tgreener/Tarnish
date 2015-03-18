//
//  List.swift
//  Tarnish
//
//  Created by Todd Greener on 2/4/15.
//  Copyright (c) 2015 Todd Greener. All rights reserved.
//

import Foundation

class List<ListType> {
    let value : ListType
    var next  : List<ListType>?
    
    init(value : ListType, next : List<ListType>? = nil) {
        self.value = value
        self.next = next
    }
}
