//
//  GASWeapon.swift
//  Abenteuer
//
//  Created by Christian Blomqvist on 2017-03-12.
//  Copyright © 2017 Christian Blomqvist. All rights reserved.
//

import Foundation

class GASWeapon : GASItem {
    
    static var itemType: GASItemType {
        return .weapon
    }
    
    var game : GASGame
    private(set) var typeId : GASItemTypeId
    var id : Int
    var value : Int
    
    var damageMin : Int
    var damageMax : Int
    
    init(game: GASGame, typeId: GASItemTypeId, value: Int, damageMin: Int, damageMax: Int) {
        self.game = game
        self.typeId = typeId
        self.value = value
        self.damageMin = damageMin
        self.damageMax = damageMax
        
        self.game.itemCount += 1
        self.id = game.itemCount
        //NSLog("GASWeapon.init: New item with id \(id).")
    }
    
    static func create(game: GASGame, id: GASItemTypeId) -> GASWeapon {
        switch(id) {
        case .wpnStick:
            return GASWeapon(game: game, typeId: id, value: 1, damageMin: 1, damageMax: 2)
            
        case .wpnBat:
            return GASWeapon(game: game, typeId: id, value: 5, damageMin: 2, damageMax: 4)
            
        case .wpnSword:
            return GASWeapon(game: game, typeId: id, value: 10, damageMin: 4, damageMax: 6)
            
        case .wpnAxe:
            return GASWeapon(game: game, typeId: id, value: 14, damageMin: 5, damageMax: 7)
            
        case .wpnPistol:
            return GASWeapon(game: game, typeId: id, value: 20, damageMin: 10, damageMax: 15)
            
        default:
            return GASWeapon(game: game, typeId: .wpnStick, value: 0, damageMin: 0, damageMax: 0)
        }
    }

}


