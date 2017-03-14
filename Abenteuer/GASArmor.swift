//
//  GASArmor.swift
//  Abenteuer
//
//  Created by Christian Blomqvist on 2017-03-12.
//  Copyright © 2017 Christian Blomqvist. All rights reserved.
//

import Foundation

class GASArmor : GASItem {
    
    static var itemType: GASItemType {
        return .armor
    }
    
    var game : GASGame
    private(set) var typeId : GASItemTypeId
    var id : Int
    var value : Int
    
    var damageBlock : Int
    var damageAbsorb : Float
    
    init(game: GASGame, typeId: GASItemTypeId, value: Int, damageBlock: Int, damageAbsorb: Float) {
        self.game = game
        self.typeId = typeId
        self.value = value
        self.damageBlock = damageBlock
        self.damageAbsorb = damageAbsorb
        
        self.game.itemCount += 1
        self.id = +game.itemCount
        //NSLog("GASArmor.init: New item with id \(id).")
    }
    
    static func create(game: GASGame, id: GASItemTypeId)-> GASArmor? {
        switch(id) {
        case .armShieldWooden:
            return GASArmor(game: game, typeId: id, value: 5, damageBlock: 1, damageAbsorb: 10.0)
            
        case .armShieldIron:
            return GASArmor(game: game, typeId: id, value: 10, damageBlock: 2, damageAbsorb: 20.0)
            
        case .armShieldSteel:
            return GASArmor(game: game, typeId: id, value: 20, damageBlock: 4, damageAbsorb: 20.0)
            
        default: return nil
        }
    }
    
}
