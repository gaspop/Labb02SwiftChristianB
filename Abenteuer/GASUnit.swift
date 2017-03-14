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
    var damage : Int
    
    init(health: Int, strength: Int, speed: Int, damage: Int) {
        self.health = health
        self.maxHealth = health
        self.strength = strength
        self.speed = speed
        self.damage = damage
    }
    
}


protocol GASUnit : CustomStringConvertible {
    
    var game : GASGame { get set }
    var id : Int { get }
    
    var name : String? { get set }
    var stats : GASUnitStats { get set }
    
    var weapon : GASWeapon? { get set }
    var armor : GASArmor? { get set }
    
    var isAlive : Bool { get }
    
    var target : GASUnit? { get set }
    
    func attack(_ target: GASUnit)
    func takeDamage(_ amount: Int)
    
}


