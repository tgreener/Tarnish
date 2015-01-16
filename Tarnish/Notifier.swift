//
//  Notifier.swift
//  Tarnish
//
//  Created by Todd Greener on 1/15/15.
//  Copyright (c) 2015 Todd Greener. All rights reserved.
//

import Foundation

class Notifier<ListenerType> {
    var listeners : [ListenerType] = [ListenerType]()
    
    func addListener(listener: ListenerType) {
        listeners.append(listener)
    }
    
    func notify(closure: (ListenerType) -> Void) {
        for listener in listeners {
            closure(listener)
        }
    }
}
