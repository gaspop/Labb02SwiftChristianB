//
//  GASScene.swift
//  Abenteuer
//
//  Created by Christian Blomqvist on 2017-03-08.
//  Copyright © 2017 Christian Blomqvist. All rights reserved.
//

import Foundation
import SpriteKit

func random(_ from: Int, _ to: Int) -> Int {
    let value : Int = Int(arc4random_uniform(UInt32(to))) + from
    NSLog("random: Range \(from) to \(to)   Result: \(value)")
    return value
}

func random(_ to: Int) -> Int {
    return random(0, to)
}

class GASScene {
    
    static let keyScene01 = "scene01"
    static let keyScene02 = "scene02"
    static let keyScene03 = "scene03"
    static let keyScene04 = "scene04"
    
    var id : String
    var paths : [GameOption] = []
    var monsters : [String] = []
    var containers : [String] = []
    
    init(id : String) {
        self.id = id
        generatePaths()
        generateMonsters()
        generateContainers()
    }
    
    func generatePaths() {
        paths = []
        var path : GameOption
        switch (random(4)) {
        case 0: path = .goNorth
        case 1: path = .goEast
        case 2: path = .goSouth
        case 3: path = .goWest
        default: path = .goNorth
        }
        paths.append(path)
    }
    
    func generateMonsters() {
        monsters = []
        let names = ["booger", "orc", "dragon", "evil cricket"]
        for _ in 0...random(3) {
            monsters.append(names[random(names.count)])
            NSLog("Scene.generateMonsters: Adding '\(monsters[monsters.count - 1])'")
        }
    }
    
    func generateContainers() {
        containers = []
        let names = ["treasure chest", "hollow tree", "wreckage"]
        if random(2) == 1 {
            containers.append(names[random(names.count)])
            NSLog("Scene.generateContainers: Adding '\(containers[containers.count - 1])'")
        }
    }
    
}
