//
//  GASConsumable.swift
//  Abenteuer
//
//  Created by Christian Blomqvist on 2017-03-19.
//  Copyright © 2017 Christian Blomqvist. All rights reserved.
//

import Foundation

class GASConsumable : GASItem {
    
    static var itemType: GASItemType {
        return .consumable
    }
    
    var game : GASGame
    private(set) var typeId : GASItemTypeId
    var id : Int
    var value : Int
    
    var healthGain : Int
    
    init(game: GASGame, typeId: GASItemTypeId, value: Int, healthGain: Int) {
        self.game = game
        self.typeId = typeId
        self.value = value
        self.healthGain = healthGain
        
        self.game.itemCount += 1
        self.id = +game.itemCount
        //NSLog("GASConsumable.init: New item with id \(id).")
    }
    
    static func create(game: GASGame, id: GASItemTypeId)-> GASConsumable {
        switch(id) {
        case .conFoodBread:
            return GASConsumable(game: game, typeId: id, value: 5, healthGain: 20)
        case .conPotion:
            return GASConsumable(game: game, typeId: id, value: 20, healthGain: 50)
        default:
            return GASConsumable(game: game, typeId: id, value: 1, healthGain: 1)
        }
    }
    
}
