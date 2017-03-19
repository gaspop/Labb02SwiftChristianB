//
//  GASEvent.swift
//  Abenteuer
//
//  Created by Christian Blomqvist on 2017-03-17.
//  Copyright © 2017 Christian Blomqvist. All rights reserved.
//

import Foundation

enum GASEventType {
    case undefined
    case game
    case scene
    case battle
    //case undefined = 0
    //case playerNewTurn = 1
    //case playerAttack = 2
    //case playerHitTarget = 3
    //case playerMissTarget = 4
    //case monsterNewTurn = 2
    //case monsterAttack = 3
    //case monster
}

class GASEvent {
    
    private static var count : Int = 0
    private static var events : [GASEvent] = []
    static var current : GASEvent? {
        return events.first
    }
    
    static func new(_ event: GASEvent) {
        events.append(event)
    }
    
    static func insert(_ event: GASEvent) {
        events.insert(event, at: 0)
    }
    
    static func finish() {
        if current != nil {
            current!.hold = false
        }
    }
    
    static func next() {
        finish()
        if current != nil {
            events.remove(at: 0)
        }
        if GASEvent.events.count == 0 {
            GASEvent.count = 0
        }
    }

    let eventType : GASEventType
    let eventId : Int
    var hold : Bool
    
    init(type: GASEventType, hold: Bool = false) {
        GASEvent.count += 1
        self.eventType = type
        self.eventId = GASEvent.count
        self.hold = hold
    }
    
}
