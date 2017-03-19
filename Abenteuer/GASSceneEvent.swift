//
//  GASSceneEvent.swift
//  Abenteuer
//
//  Created by Christian Blomqvist on 2017-03-18.
//  Copyright © 2017 Christian Blomqvist. All rights reserved.
//

import Foundation

enum GASSceneEventType {
    
    case newScene
    case playerMakeMove
    
}

class GASSceneEvent : GASEvent {
    
    let type : GASSceneEventType
    
    init(_ type: GASSceneEventType, hold: Bool = false) {
        self.type = type
        super.init(type: .scene, hold: hold)
    }
    
}
