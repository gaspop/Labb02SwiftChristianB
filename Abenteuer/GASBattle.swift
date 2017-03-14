//
//  GASBattle.swift
//  Abenteuer
//
//  Created by Christian Blomqvist on 2017-03-12.
//  Copyright © 2017 Christian Blomqvist. All rights reserved.
//

import Foundation

class GASBattle {
    
    var game : GASGame
    private var _combatants : [GASUnit]
    var combatants : [GASUnit] {
        get {
            return _combatants.filter( { unit in unit.isAlive } )
        }
        set(units) {
            _combatants = units
        }
    }
    var turnList : [GASUnit]
    
    var player : GASUnit? {
        for c in combatants {
            if c.id == 0 && c.isAlive {
                return c
            }
        }
        return nil
    }
    
    var playerIsAlive : Bool {
        if let player = self.player {
            return player.isAlive
        }
        return false
    }
    
    var isBattleFinished : Bool {
        return !playerIsAlive || (playerIsAlive && combatants.count == 1)
    }
    
    var isAwaitingUnitMove : Bool {
        if let _ = turnList.first {
            return true
        }
        return false
    }
    
    init(game: GASGame, combatants: [GASUnit]) {
        self.game = game
        self._combatants = combatants
        self.turnList = []
        NSLog("GASBattle.init: New battle with \(combatants.count) combatants.")
        newRound()
    }
    
    //var currentTurn
    
    func newRound() {
        //NSLog("GASBattle.newRound: Attempting to start new round.")
        if !isBattleFinished {
            NSLog("GASBattle.newRound: New round, \(combatants.count) combatants remain.")
            turnList = combatants.sorted(by: { c in c.0.stats.speed > c.1.stats.speed } )
            newTurn()
        } else {
            if playerIsAlive {
                NSLog("GASBattle.newRound: Battle is over, the player has won battle, all monsters are dead.")
            } else {
                NSLog("GASBattle.newRound: Battle is over, the player has lost.")
            }
        }

    }
    
    func newTurn() {
        //NSLog("GASBattle.newTurn: turnList = \(turnList)")
        if let unit = turnList.first {
            if !unit.isAlive {
                NSLog("GASBattle.newTurn: Unit '\(unit.id)' is dead, can't take turn.")
                turnList.remove(at: 0)
                newTurn()
            }
        }
    }
    
    func takeTurn() {
        var unit = turnList.first!
        if let target = unit.target {
            if !target.isAlive {
                setTarget(forUnit: unit, target: getTarget(forUnit: unit))
                takeTurn()
                return
            } else {
                unit.attack(target)
                turnList.remove(at: 0)
            }
        } else {
            // Pick new target for unit
            setTarget(forUnit: unit, target: getTarget(forUnit: unit))
            
            if unit.target != nil {
                takeTurn()
                return
            } else {
                NSLog("GASBattle.takeTurn: Unit '\(unit.id)' couldn't find any targets.")
                turnList.remove(at: 0)
                return
            }
            
        }
    }
    
    func setTarget(forUnit: GASUnit, target: GASUnit?) {
        var unit = forUnit
        if let target = target {
            NSLog("GASBattle.takeTurn: Target set to id \(target.id)")
            unit.target = target
        } else {
            unit.target = nil
        }
    }
    
    func getTarget(forUnit: GASUnit) -> GASUnit? {
        
        if let player = forUnit as? GASPlayer {
            for c in combatants {
                if c.isAlive && (c.id != player.id) {
                    return c
                }
            }
        } else if forUnit is GASMonster {
            // NOTE TO SELF: WHAT ZE FECK? is???
            return self.player
        } else {
            return nil
        }
        return nil
    }
    

    
}
