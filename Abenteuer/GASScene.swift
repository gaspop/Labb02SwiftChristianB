//
//  GASScene.swift
//  Abenteuer
//
//  Created by Christian Blomqvist on 2017-03-08.
//  Copyright © 2017 Christian Blomqvist. All rights reserved.
//

import Foundation
import SpriteKit

class GASScene {
    
    static let keyScene01 = "scene01"
    static let keyScene02 = "scene02"
    static let keyScene03 = "scene03"
    static let keyScene04 = "scene04"
    
    var id : String
    var paths : [GameOption] = []
    var monsters : [GASMonster] = []
    var containers : [String] = []
    
    init(id : String) {
        self.id = id
        generatePaths()
        generateMonsters()
        generateContainers()
    }
    
    func generatePaths() {
        paths = []
        if random(2)==1 {
            paths.append(.travel)
        }
    }
    
    func generateMonsters() {
        monsters = []
        for i in 0..<(random(4)) {
            let gap = 256
            let monster = GASMonster(type: .hoodlum,
                                     scene: self, game: nil, name: nil,
                                     stats: GASUnitStats(health: 50, strength: 4, speed: 2),
                                     geometry: GASSceneObjectGeometry(x: 256 + Float(gap * i), y: 0, width: 512, height: 768))
            monsters.append(monster)
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
