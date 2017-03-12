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
    
    private(set) var itemId : GASItemId
    var value : Int
    
    var damageMin : Int
    var damageMax : Int
    
    init(itemId: GASItemId, value: Int, damageMin: Int, damageMax: Int) {
        self.itemId = itemId
        self.value = value
        self.damageMin = damageMin
        self.damageMax = damageMax
    }
    
    static func create(_ id: GASItemId) -> GASWeapon? {
        switch(id) {
        case .wpnStick:
            return GASWeapon(itemId: id, value: 1, damageMin: 1, damageMax: 2)
            
        case .wpnBat:
            return GASWeapon(itemId: id, value: 5, damageMin: 2, damageMax: 4)
            
        case .wpnSword:
            return GASWeapon(itemId: id, value: 10, damageMin: 4, damageMax: 6)
            
        case .wpnAxe:
            return GASWeapon(itemId: id, value: 14, damageMin: 5, damageMax: 7)
            
        case .wpnPistol:
            return GASWeapon(itemId: id, value: 20, damageMin: 10, damageMax: 15)
            
        default: return nil
        }
    }

}


