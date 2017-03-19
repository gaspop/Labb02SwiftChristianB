//
//  GASHelper.swift
//  Abenteuer
//
//  Created by Christian Blomqvist on 2017-03-11.
//  Copyright © 2017 Christian Blomqvist. All rights reserved.
//

import Foundation

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
