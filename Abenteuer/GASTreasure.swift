//
//  GASTreasure.swift
//  Abenteuer
//
//  Created by Christian Blomqvist on 2017-03-19.
//  Copyright © 2017 Christian Blomqvist. All rights reserved.
//

import Foundation

class GASTreasure : GASItem {
    
    static var itemType: GASItemType {
        return .treasure
    }
    
    var game : GASGame
    private(set) var typeId : GASItemTypeId
    var id : Int
    var value : Int
    
    init(game: GASGame, typeId: GASItemTypeId, value: Int) {
        self.game = game
        self.typeId = typeId
        self.value = value
        
        self.game.itemCount += 1
        self.id = +game.itemCount
    }
    
    static func create(game: GASGame, id: GASItemTypeId)-> GASTreasure {
        switch(id) {
        case .treGoldCoin:
            return GASTreasure(game: game, typeId: id, value: 10)
        case .treNecklace:
            return GASTreasure(game: game, typeId: id, value: 25)
        case .treJewel:
            return GASTreasure(game: game, typeId: id, value: 50)
        default:
            return GASTreasure(game: game, typeId: id, value: 1)
        }
    }
    
}
