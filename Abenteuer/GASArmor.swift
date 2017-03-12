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
    
    private(set) var itemId : GASItemId
    var value : Int
    
    var damageBlock : Int
    var damageAbsorb : Float
    
    init(itemId: GASItemId, value: Int, damageBlock: Int, damageAbsorb: Float) {
        self.itemId = itemId
        self.value = value
        self.damageBlock = damageBlock
        self.damageAbsorb = damageAbsorb
    }
    
    static func create(_ id: GASItemId) -> GASArmor? {
        switch(id) {
        case .armShieldWooden:
            return GASArmor(itemId: id, value: 5, damageBlock: 1, damageAbsorb: 10.0)
        case .armShieldIron:
            return GASArmor(itemId: id, value: 10, damageBlock: 2, damageAbsorb: 20.0)
        case .armShieldSteel:
            return GASArmor(itemId: id, value: 20, damageBlock: 4, damageAbsorb: 20.0)
            
        default: return nil
        }
    }
    
}
