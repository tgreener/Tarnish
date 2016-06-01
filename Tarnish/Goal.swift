//
//  Goal.swift
//  Tarnish
//
//  Created by Todd Greener on 2/28/15.
//  Copyright (c) 2015 Todd Greener. All rights reserved.
//

import Foundation

protocol Goal {
    func addAction(action: CharacterAction) -> Void
    func update(delta: NSTimeInterval) -> Void
}

class GoalBase : Goal {
    var actionList : [CharacterAction] = [CharacterAction]()
    
    convenience init(actions: [CharacterAction]) {
        self.init()
        actionList += actions
    }
    
    func addAction(action: CharacterAction) -> Void {
        actionList.append(action);
    }
    
    func update(delta: NSTimeInterval) {
        if actionList.first?.update(delta) != nil {
            if actionList.first!.isComplete() {
                actionList.removeAtIndex(0);
            }
        }
    }
}
