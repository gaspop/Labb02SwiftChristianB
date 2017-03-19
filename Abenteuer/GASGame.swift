//
//  GASGame.swift
//  Abenteuer
//
//  Created by Christian Blomqvist on 2017-03-08.
//  Copyright © 2017 Christian Blomqvist. All rights reserved.
//

import Foundation

class GameStats {
    static let playerChanceToHit : Int = 70
    static let monsterChanceToHit : Int = 45
    static let healthIncreaseFactor : Float = 0.75
    static let maxHealthIncreaseBase: Int = 20
    static let experienceBase: Int = 25
    static let experienceIncreaseBase : Int = 2
}

class GASGame {
    
    static let playerId : Int = 0

    var player : GASPlayer?
    var scene : GASScene?
    var battle : GASBattle?

    var sceneCount : Int
    var monsterCount : Int
    var itemCount : Int
    
    init() {
        GASEvent.new(GASGameEvent(.newGame))
        sceneCount = 0
        monsterCount = 0
        itemCount = 0
    }
    
    func newScene() {
        let rndScene : [GASSceneType] = [.field, .forestInside, .forestOutside, .hills]
        let rndIndex = random(rndScene.count)
        //NSLog("GASGame.newScene: index = \(rndIndex)   scene = \(rndScene[rndIndex])")
        scene = GASScene(game: self, type: rndScene[rndIndex])
        GASEvent.new(GASSceneEvent(.newScene))
        if scene!.monsters.count > 0 {
            newBattle()
        } else {
            GASEvent.new(GASSceneEvent(.describeScene, hold: true))
            newPlayerMove()
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
        GASEvent.new(GASBattleEvent(.battleEnd, hold: true))
        GASEvent.new(GASSceneEvent(.describeScene, hold: true))
        newPlayerMove()
    }
    
    func collectBattleRewards() {
        var xpReward = 0
        for m in self.scene!.monsters {
            xpReward += m.experienceReward
        }
        NSLog("xpReward: \(xpReward)")
        player!.experience += xpReward
        scene!.gatherLoot()
    }
    
    func newPlayerMove() {
        GASEvent.new(GASSceneEvent(.playerMakeMove, hold: true))
    }

}
