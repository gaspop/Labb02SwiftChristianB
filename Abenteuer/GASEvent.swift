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
            var shit = ""
            if let event = current! as? GASGameEvent {
                shit = "\(event.type)"
            } else if let event = current! as? GASSceneEvent {
                shit = "\(event.type)"
            } else if let event = current! as? GASBattleEvent {
                shit = "\(event.type)"
            }
            print("jumping to next from: \(shit)")
            events.remove(at: 0)
        }
        if GASEvent.events.count == 0 {
            GASEvent.count = 0
        }
    }
    
    static func clearAll() {
        events = []
        GASEvent.count = 0
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
    
    static func list() -> String {
        var list = "Events:"
        for e in events {
            if let event = e as? GASGameEvent {
                list += "\n\(event.type)"
            } else if let event = e as? GASSceneEvent {
                list += "\n\(event.type)"
            } else if let event = e as? GASBattleEvent {
                list += "\n\(event.type)"
            }
        }
        return list
    }
    
}
