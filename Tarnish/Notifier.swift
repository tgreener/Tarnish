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

class Listener<ListenerType: AnyObject> {
    unowned let value : ListenerType // TODO: Use this once the compiler is updated. The unowned and AnyObject parts throw it for a loop (figuratively).
    init(value: ListenerType) {
        self.value = value
    }
}
