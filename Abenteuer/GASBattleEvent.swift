//
//  GASBattleEvent.swift
//  Abenteuer
//
//  Created by Christian Blomqvist on 2017-03-17.
//  Copyright © 2017 Christian Blomqvist. All rights reserved.
//

import Foundation

class GASBattleEvent : GASEvent {
    
    let type : GASBattleEventType
    let unitId : Int?
    let targetId : Int?
    let value : Float?
    
    init(_ type: GASBattleEventType, unitId: Int?, targetId: Int?, value: Float?, hold: Bool = false) {
        self.type = type
        self.unitId = unitId
        self.targetId = targetId
        self.value = value
        super.init(type: .battle, hold: hold)
    }
    
    init(_ type: GASBattleEventType, hold: Bool = false) {
        self.type = type
        self.unitId = nil
        self.targetId = nil
        self.value = nil
        super.init(type: .battle, hold: hold)
    }
    
}

enum GASBattleEventType {
    
    case battleStart
    case battleEnd
    case newTurnForPlayer
    case newTurnForMonster
    case playerAttacks
    case playerHitTarget
    case playerMissTarget
    case playerDies
    case monsterAttacks
    case monsterHitTarget
    case monsterMissTarget
    case monsterDies
    
}
