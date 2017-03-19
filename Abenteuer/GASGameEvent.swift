//
//  GASGameEvent.swift
//  Abenteuer
//
//  Created by Christian Blomqvist on 2017-03-18.
//  Copyright © 2017 Christian Blomqvist. All rights reserved.
//

import Foundation

enum GASGameEventType {
    
    case newGame
    case gameStart
    case gameEnd
    case showInventory
    case showContainer
    case showLoot
    
}

class GASGameEvent : GASEvent {
    
    let type : GASGameEventType
    
    init(_ type: GASGameEventType, hold: Bool = false) {
        self.type = type
        super.init(type: .game, hold: hold)
    }
    
}
