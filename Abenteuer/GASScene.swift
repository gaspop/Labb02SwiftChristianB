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
    
    var game : GASGame
    var id : String
    var paths : [GASGameOptionType] = []
    var monsters : [GASMonster] = []
    var containers : [String] = []
    
    init(game: GASGame, id : String) {
        self.game = game
        self.id = id
        generatePaths()
        generateMonsters()
        generateContainers()
    }
    
    func generatePaths() {
        paths = []
        paths.append(.travel)
    }
    
    func generateMonsters() {
        monsters = []
        for i in 0..<(random(4)) {
            let gap = 256
            let monster = GASMonster(type: .hoodlum,
                                     scene: self, game: self.game,
                                     stats: GASUnitStats(health: 50, strength: 2, speed: 2, damage: 2),
                                     geometry: GASSceneObjectGeometry(x: 256 + Float(gap * i), y: 0, width: 512, height: 768),
                                     xpReward: 15,
                                     name: nil,
                                     weapon: GASWeapon.create(game: game, id: .wpnStick),
                                     armor: nil,
                                     inventory: nil)
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
