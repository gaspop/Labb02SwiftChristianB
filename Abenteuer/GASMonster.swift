//
//  GASMonster.swift
//  Abenteuer
//
//  Created by Christian Blomqvist on 2017-03-12.
//  Copyright © 2017 Christian Blomqvist. All rights reserved.
//

import Foundation

class GASMonster : GASSceneObject, GASUnit, GASInventory {
    
    static var sceneObjectType : GASObjectType {
        get { return .monster }
    }
    
    var game : GASGame
    var scene : GASScene
    var type : GASMonsterType
    var id : Int
    
    var geometry : GASSceneObjectGeometry
    
    var name : String?
    var stats : GASUnitStats
    var weapon : GASWeapon?
    var armor : GASArmor?
    var inventory : [GASItem]
    
    var experienceReward : Int
    
    var target : GASUnit?
    
    var isAlive : Bool {
        return stats.health > 0
    }
    
    var description: String {
        return "Monster Id: \(id)   Type: \(type)"
    }
    
    init(type: GASMonsterType, scene: GASScene, game: GASGame, stats: GASUnitStats, geometry: GASSceneObjectGeometry, xpReward: Int, name: String?, weapon: GASWeapon?, armor: GASArmor?, inventory: [GASItem]?) {
        self.type = type
        self.scene = scene
        self.game = game
        self.stats = stats
        self.geometry = geometry
        self.experienceReward = xpReward
        self.name = name
        self.weapon = weapon
        self.armor = armor
        
        if let inventory = inventory {
            self.inventory = inventory
        } else {
            self.inventory = []
        }
        
        self.game.monsterCount += 1
        self.id = game.monsterCount
        //NSLog("GASMonster.init: New monster with id \(id).")
    }
    
    func position(_ x: Float, _ y: Float) {
        geometry.x = x
        geometry.y = y
    }
    func size(_ width: Float, _ height: Float) {
        geometry.width = width
        geometry.height = height
    }
    
    func attack(_ target: GASUnit) {
        var weaponDamage = 0
        if let weapon = self.weapon {
            weaponDamage = random(weapon.damageMin, weapon.damageMax + 1)
        }
        let damage = (stats.damage + weaponDamage) * stats.strength
        NSLog("GASMonster.attack(): Monster '\(id)' attacking with \(damage) damage.")
        target.takeDamage(damage)
    }
    
    func takeDamage(_ amount: Int) {
        var damageBlock = 0
        if let armor = self.armor {
            let absorb = Int(Float(amount) * (Float(armor.damageAbsorb) / 100).rounded())
            damageBlock = armor.damageBlock + absorb
        }
        let damageTaken = max(0, amount - damageBlock)
        
        NSLog("GASMonster.takedamage(): Monster '\(id)' took \(damageTaken) damage from a total of \(amount) dealt.")
        self.stats.health -= damageTaken
        if !self.isAlive {
            GASEvent.new(GASBattleEvent(.monsterDies))
        }
    }
    
}

enum GASMonsterType : Int {
    
    case idiot = 1
    case thug = 2
    case jerk = 3
    case spider = 4
    case slime = 5
    case duck = 6
    
}


