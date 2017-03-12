//
//  GASUnit.swift
//  Abenteuer
//
//  Created by Christian Blomqvist on 2017-03-12.
//  Copyright © 2017 Christian Blomqvist. All rights reserved.
//

import Foundation

class GASUnitStats {
    
    var health : Int
    var maxHealth : Int
    var strength : Int
    var speed : Int
    
    init(health: Int, strength: Int, speed: Int) {
        self.health = health
        self.maxHealth = health
        self.strength = strength
        self.speed = speed
    }
    
}


protocol GASUnit {
    
    var game : GASGame? { get set }
    
    var name : String? { get set }
    var stats : GASUnitStats { get set }
    
    // var weapon : GASWeapon? { get set }
    // var armor : GASArmor? { get set }
    
    func attack(_ target: GASUnit)
    func takeDamage(_ amount: Int)
    
}

class GASMonster : GASSceneObject, GASUnit, GASInventory {
    
    static var sceneObjectType : GASObjectType {
        get { return .monster }
    }
    
    var game : GASGame?
    var scene : GASScene
    var type : GASMonsterType
    
    var geometry : GASSceneObjectGeometry
    
    var name : String?
    var stats : GASUnitStats
    
    init(type: GASMonsterType, scene: GASScene, game: GASGame?, name: String?, stats: GASUnitStats, geometry: GASSceneObjectGeometry) {
        self.type = type
        self.scene = scene
        self.game = game
        self.name = name
        self.stats = stats
        self.geometry = geometry
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
        NSLog("GASMonster.attack(): Blep!")
    }
    
    func takeDamage(_ amount: Int) {
        NSLog("GASMonster.takedamage(): Heck!")
        self.stats.health -= amount
    }
    
}

enum GASMonsterType : Int {
    
    case hoodlum = 1
    case slime = 2
    case fiend = 3
    
}
