//
//  GASItem.swift
//  Abenteuer
//
//  Created by Christian Blomqvist on 2017-03-12.
//  Copyright © 2017 Christian Blomqvist. All rights reserved.
//

import Foundation

enum GASItemType : Int {
    case weapon = 1
    case armor = 2
    case consumable = 3
    case treasure = 4
}

protocol GASItem {
    
    static var itemType : GASItemType { get }
    var itemId : GASItemId { get }
    var value : Int { get set }
    
}

enum GASItemId : Int {
    case wpnStick           = 1
    case wpnBat             = 2
    case wpnSword           = 3
    case wpnAxe             = 4
    case wpnPistol          = 5
    
    case armShieldWooden    = 101
    case armShieldIron      = 102
    case armShieldSteel     = 103
    
    case conFoodBread       = 201
    case conFoodApple       = 202
    case conFoodBanana      = 203
    case conFoodChicken     = 204
    case conFoodFish        = 205
    
    case treGoldCoin        = 301
    case treNecklace        = 302
    case treJewel           = 303
    case treDiamond         = 304
}
