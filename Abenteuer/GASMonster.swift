//
//  GASMonster.swift
//  Abenteuer
//
//  Created by Christian Blomqvist on 2017-03-12.
//  Copyright © 2017 Christian Blomqvist. All rights reserved.
//

import Foundation


enum GASMonsterType : Int {
    
    case idiot = 1
    case thug = 2
    case jerk = 3
    case spider = 4
    case slime = 5
    case duck = 6
    
}

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
        if (100 - GameStats.monsterChanceToHit) < random(100) {
            var weaponDamage = 0
            if let weapon = self.weapon {
                weaponDamage = random(weapon.damageMin, weapon.damageMax + 1)
            }
            let damage = (stats.damage + weaponDamage) * stats.strength
            NSLog("GASMonster.attack(): Monster '\(id)' attacking with \(damage) damage.")
            
            var previousHealth = target.stats.health
            target.takeDamage(damage)
            previousHealth -= target.stats.health
            GASEvent.new(GASBattleEvent(.monsterHitTarget, unitId: id, targetId: 0, value: Float(previousHealth), hold: true))
        } else {
            GASEvent.new(GASBattleEvent(.monsterMissTarget, unitId: id, targetId: 0, value: 0, hold: true))
        }
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
    }
    
    static func create(game: GASGame, type: GASMonsterType) -> GASMonster {
        switch(type) {
        case .idiot:
            return GASMonster(type: type, scene: game.scene!, game: game,
                              stats: statsForMonsterType(type),
                              geometry: geometryForMonsterType(type),
                              xpReward: 10, name: nil,
                              weapon: GASWeapon.create(game: game, id: .wpnStick),
                              armor: nil,
                              inventory: [GASConsumable.create(game: game, id: .conFoodBread),
                                          GASTreasure.create(game: game, id: .treGoldCoin)])
        case .thug:
            return GASMonster(type: type, scene: game.scene!, game: game,
                              stats: statsForMonsterType(type),
                              geometry: geometryForMonsterType(type),
                              xpReward: 25, name: nil,
                              weapon: GASWeapon.create(game: game, id: .wpnBat),
                              armor: nil,
                              inventory: [GASConsumable.create(game: game, id: .conFoodBread),
                                          GASTreasure.create(game: game, id: .treGoldCoin),
                                          GASWeapon.create(game: game, id: .wpnBat),
                                          GASArmor.create(game: game, id: .armShieldWooden)])
        case .jerk:
            return GASMonster(type: type, scene: game.scene!, game: game,
                              stats: statsForMonsterType(type),
                              geometry: geometryForMonsterType(type),
                              xpReward: 25, name: nil,
                              weapon: GASWeapon.create(game: game, id: .wpnSword),
                              armor: nil,
                              inventory: [GASConsumable.create(game: game, id: .conFoodBread),
                                          GASTreasure.create(game: game, id: .treGoldCoin),
                                          GASTreasure.create(game: game, id: .treNecklace),
                                          GASWeapon.create(game: game, id: .wpnSword)])
        case .spider:
            return GASMonster(type: type, scene: game.scene!, game: game,
                              stats: statsForMonsterType(type),
                              geometry: geometryForMonsterType(type),
                              xpReward: 40, name: nil,
                              weapon: nil,
                              armor: nil,
                              inventory: [GASConsumable.create(game: game, id: .conPotion),
                                          GASTreasure.create(game: game, id: .treGoldCoin),
                                          GASTreasure.create(game: game, id: .treNecklace),
                                          GASWeapon.create(game: game, id: .treJewel)])
        case .slime:
            return GASMonster(type: type, scene: game.scene!, game: game,
                              stats: statsForMonsterType(type),
                              geometry: geometryForMonsterType(type),
                              xpReward: 80, name: nil,
                              weapon: nil,
                              armor: nil,
                              inventory: [GASConsumable.create(game: game, id: .conPotion),
                                          GASTreasure.create(game: game, id: .treGoldCoin),
                                          GASTreasure.create(game: game, id: .treNecklace),
                                          GASTreasure.create(game: game, id: .treJewel),
                                          GASWeapon.create(game: game, id: .wpnAxe),
                                          GASArmor.create(game: game, id: .armShieldSteel)])
        case .duck:
            return GASMonster(type: type, scene: game.scene!, game: game,
                              stats: statsForMonsterType(type),
                              geometry: geometryForMonsterType(type),
                              xpReward: 125, name: nil,
                              weapon: GASWeapon.create(game: game, id: .wpnPistol),
                              armor: nil,
                              inventory: [GASConsumable.create(game: game, id: .conPotion),
                                          GASTreasure.create(game: game, id: .treGoldCoin),
                                          GASTreasure.create(game: game, id: .treNecklace),
                                          GASTreasure.create(game: game, id: .treJewel),
                                          GASWeapon.create(game: game, id: .wpnAxe),
                                          GASArmor.create(game: game, id: .armShieldSteel)])
        }
    }

}

func statsForMonsterType(_ type: GASMonsterType) -> GASUnitStats {
    switch(type) {
    case .idiot:
        return GASUnitStats(health: 12, strength: 1, speed: 4, damage: 2)
    case .thug:
        return GASUnitStats(health: 30, strength: 3, speed: 1, damage: 1)
    case .jerk:
        return GASUnitStats(health: 20, strength: 2, speed: 2, damage: 2)
    case .spider:
        return GASUnitStats(health: 30, strength: 3, speed: 4, damage: 6)
    case .slime:
        return GASUnitStats(health: 50, strength: 4, speed: 1, damage: 8)
    case .duck:
        return GASUnitStats(health: 70, strength: 2, speed: 2, damage: 3)
    }
}

func geometryForMonsterType(_ type: GASMonsterType) -> GASSceneObjectGeometry {
    switch(type) {
    case .idiot:
        return GASSceneObjectGeometry(x: 0, y: 0, width: 512, height: 512)
    case .thug:
        return GASSceneObjectGeometry(x: 0, y: 0, width: 512, height: 512)
    case .jerk:
        return GASSceneObjectGeometry(x: 0, y: 0, width: 512, height: 768)
    case .spider:
        return GASSceneObjectGeometry(x: 0, y: 0, width: 512, height: 512)
    case .slime:
        return GASSceneObjectGeometry(x: 0, y: 0, width: 512, height: 512)
    case .duck:
        return GASSceneObjectGeometry(x: 0, y: 0, width: 512, height: 512)
    }
}


