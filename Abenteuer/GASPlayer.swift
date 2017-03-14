//
//  GASPlayer.swift
//  Abenteuer
//
//  Created by Christian Blomqvist on 2017-03-12.
//  Copyright © 2017 Christian Blomqvist. All rights reserved.
//

import Foundation

class GameStats {
    static let healthIncreaseFactor : Float = 0.75
    static let maxHealthIncreaseBase: Int = 20
    static let experienceBase: Int = 25
    static let experienceIncreaseBase : Int = 2
}

class GASPlayer : GASUnit, GASInventory {
    /*
    static var sceneObjectType : GASObjectType {
        get { return .player }
    }
     */
    
    var game : GASGame
    var id : Int
    
    var geometry : GASSceneObjectGeometry
    
    var name : String?
    var stats : GASUnitStats
    var money : Int
    var weapon : GASWeapon?
    var armor : GASArmor?
    var inventory : [GASItem] = []
    
    var target : GASUnit?
    
    var level : Int
    var _experience : Int
    var experience : Int {
        get {
            return _experience
        }
        set(value) {
            _experience = value
            if _experience >= experienceLimit {
                levelUp()
            }
        }
    }
    
    var experienceLimit : Int {
        return GameStats.experienceBase * Int(pow(Float(GameStats.experienceIncreaseBase), Float(level)))
    }
    
    var isAlive : Bool {
        return stats.health > 0
    }
    
    var description: String {
        return "Player"
    }
    
    init(game: GASGame, name: String?, stats: GASUnitStats, geometry: GASSceneObjectGeometry) {
        self.game = game
        self.name = name
        self.stats = stats
        self.geometry = geometry
        self.money = 0
        self.level = 1
        _experience = 0
        
        id = GASGame.playerId
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
        let baseDamage = Int(pow(Float(max(stats.damage, 2)),Float(level) / 3).rounded())
        let damage = (baseDamage + weaponDamage) * stats.strength
        NSLog("GASPlayer.attack(): Attacking with \(damage) damage.")
        target.takeDamage(damage)
    }
    
    func takeDamage(_ amount: Int) {
        var damageBlock = 0
        let baseBlock = Int(pow(Float(2),Float(level) / 3).rounded())
        if let armor = self.armor {
            let absorb = Int(Float(amount) * (Float(armor.damageAbsorb) / 100).rounded())
            damageBlock = armor.damageBlock + absorb
        }
        let damageTaken = max(0, amount - damageBlock - baseBlock)
        
        NSLog("GASPlayer.takedamage(): Took \(damageTaken) damage from a total of \(amount) dealt.")
        self.stats.health -= damageTaken
        
    }
    
    func levelUp() {
        while(experience >= experienceLimit) {
            let bonusHealth = GameStats.maxHealthIncreaseBase * level
            stats.maxHealth += bonusHealth
            stats.health += Int(Float(bonusHealth) * GameStats.healthIncreaseFactor)
            level += 1
        }
        NSLog("Player.levelUp: Level \(level) reached.")
        NSLog("Hitpoints: \(stats.health) / \(stats.maxHealth)")
        NSLog("Experience: \(experience) / \(experienceLimit)")
        NSLog("Base Damage: \(Int(pow(Float(max(stats.damage, 2)),Float(level) / 3).rounded()))")
        NSLog("Unarmed Damage: \(Int(pow(Float(max(stats.damage, 2)),Float(level) / 3).rounded()) * stats.strength)")
        NSLog("Base Block: \(Int(pow(Float(2),Float(level) / 3).rounded()))")
        NSLog("Player.levelUp: Next level experience limit is \(experienceLimit).")
    }
    
}

