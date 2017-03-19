//
//  GASGame.swift
//  Abenteuer
//
//  Created by Christian Blomqvist on 2017-03-08.
//  Copyright © 2017 Christian Blomqvist. All rights reserved.
//

import Foundation

enum GASGameOptionType : Int {
    case attack = 0
    case search = 1
    case gather = 2
    case inventory = 3
    case travel = 4
    case `continue` = 5
}

func stringForOption(_ option: GASGameOptionType) -> String {
    switch(option) {
    case .attack:       return "Attack"
    case .search:       return "Search"
    case .gather:       return "Gather loot"
    case .inventory:    return "Inventory"
    case .travel:       return "Travel onwards"
    case .continue:     return "Continue"
    }
}

class GASGameOption {
    
    var type : GASGameOptionType
    var text : String
    
    init(type: GASGameOptionType, text: String) {
        self.type = type
        self.text = text
    }
    
}

class GASGame {
    
    static let playerId : Int = 0

    var player : GASPlayer?
    var scene : GASScene?
    var battle : GASBattle?
    var options : [GASGameOption]?

    var monsterCount : Int
    var itemCount : Int
    
    init() {
        GASEvent.new(GASGameEvent(.newGame))
        monsterCount = 0
        itemCount = 0
    }
    
    func newScene() {
        let rndScene = [GASScene.keyScene01, GASScene.keyScene02, GASScene.keyScene03, GASScene.keyScene04]
        let rndIndex = Int(arc4random_uniform(UInt32(rndScene.count)))
        NSLog("GASGame.newScene: index = \(rndIndex)   scene = \(rndScene[rndIndex])")
        scene = GASScene(game: self, id: rndScene[rndIndex])
        GASEvent.new(GASSceneEvent(.newScene))
        if scene!.monsters.count > 0 {
            newBattle()
        } else {
            newPlayerMove()
            //GASEvent.new(GASSceneEvent(.playerMakeMove, hold: true))
        }
    }
    
    func newBattle() {
        if let scene = self.scene,
           let player = self.player,
           player.isAlive && scene.monsters.count > 0 {
            var combatants : [GASUnit]
            combatants = Array(scene.monsters)
            combatants.append(player)
            battle = GASBattle(game: self, combatants: combatants)
            //GASEvent.new(GASBattleEvent(type: .battleStart))
        } else {
            NSLog("GASGame.newBattle: Could not start new battle!")
            endBattle()
        }
    }
    
    func startBattle() {
        if let battle = self.battle {
            battle.evaluate()
        }
    }
    
    func endBattle() {
        self.battle = nil
        GASEvent.new(GASBattleEvent(.battleEnd))
        newPlayerMove()
    }
    
    func newPlayerMove() {
        GASEvent.new(GASSceneEvent(.playerMakeMove, hold: true))
    }
    
    func continueBattle() {
        if let battle = self.battle {
            if battle.isAwaitingUnitMove {
                battle.takeTurn()
                battle.newTurn()
                evaluateBattle()
            } else {
                battle.newRound()
                continueBattle()
            }
        }
    }
    
    func evaluateBattle() {
        if let battle = self.battle {
            if battle.isBattleFinished {
                NSLog("GASGame.evaluateBattle: Battle is over")
                if player!.isAlive {
                    NSLog("GASGame.evaluateBattle: Collecting rewards for player.")
                    NSLog("Player needs \(player!.experienceLimit) to advance.")
                    var xpReward = 0
                    for m in self.scene!.monsters {
                        xpReward += m.experienceReward
                    }
                    NSLog("xpReward: \(xpReward)")
                    NSLog("experience pre: \(player!.experience)")
                    player!.experience += xpReward
                    NSLog("experience post: \(player!.experience)")
                    scene!.gatherLoot()
                }
                self.battle = nil
                self.scene!.monsters = self.scene!.monsters.filter( { monster in monster.isAlive } )
            } else {
                if !battle.isAwaitingUnitMove {
                    battle.newRound()
                }
            }
        }
        generateOptions()
    }
    
    func generateOptions() {
        
        options = []
    
        if let scene = self.scene {
            if let battle = self.battle,
                let unit = battle.turnList.first {
                //NSLog("GASGame.generateOptions: Adding Battle options.")
                if unit.id == GASGame.playerId {
                    options!.append(GASGameOption(type: .attack, text: stringForOption(.attack)))
                } else {
                    options!.append(GASGameOption(type: .continue, text: stringForOption(.continue)))
                }
            } else {
                //NSLog("GASGame.generateOptions: Adding Adventure options.")
                if scene.paths.count > 0 {
                    options!.append(GASGameOption(type: .travel, text: stringForOption(.travel)))
                    NSLog("Travel option!")
                }
                if scene.loot.inventory.count > 0 {
                    options!.append(GASGameOption(type: .gather, text: stringForOption(.gather)))
                }
                if let container = scene.containers.first,
                    container.inventory.count > 0 {
                    options!.append(GASGameOption(type: .search,
                                                  text: "\(stringForOption(.search)) \(stringForContainer(container.type))" ))
                    NSLog("Container option")
                }
            }
            options!.append(GASGameOption(type: .inventory, text: stringForOption(.inventory)))
        }
        
        options = options!.count > 0 ? options : nil
    }

}
