//
//  GASHelper.swift
//  Abenteuer
//
//  Created by Christian Blomqvist on 2017-03-11.
//  Copyright © 2017 Christian Blomqvist. All rights reserved.
//

import Foundation
import SpriteKit

func random(_ from: Int, _ to: Int) -> Int {
    let value : Int = Int(arc4random_uniform(UInt32(to))) + from
    //NSLog("random: Range \(from) to \(to)   Result: \(value)")
    return value
}

func random(_ to: Int) -> Int {
    return random(0, to)
}

class UserInteraction {
    static var isEnabled : Bool = true
}

class GASPivot {
    static var topLeft : CGPoint        { return CGPoint(x: 0.0, y: 1.0) }
    static var center : CGPoint         { return CGPoint(x: 0.5, y: 0.5) }
    static var bottomCenter : CGPoint   { return CGPoint(x: 0.5, y: 0.0) }
}
