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
    var containers : [GASContainer] = []
    private var _loot : GASContainer?
    var loot : GASContainer {
        if _loot == nil {
            _loot = GASContainer(type: .undefined, scene: self)
        }
        return _loot!
    }
    
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
            let monster = GASMonster(type: .jerk,
                                     scene: self, game: self.game,
                                     stats: GASUnitStats(health: 50, strength: 2, speed: 2, damage: 2),
                                     geometry: GASSceneObjectGeometry(x: 256 + Float(gap * i), y: 0, width: 512, height: 768),
                                     xpReward: 15,
                                     name: nil,
                                     weapon: GASWeapon.create(game: game, id: .wpnStick),
                                     armor: nil,
                                     inventory: [GASWeapon.create(game: game, id: .wpnSword)])
            monsters.append(monster)
        }
    }
    
    func gatherLoot() {
        for m in monsters {
            if !m.isAlive {
                loot.inventory.append(contentsOf: m.inventory)
            }
        }
    }
    
    
    func generateContainers() {
        containers = []
        let possible = [GASContainer.init(type: .chest, scene: self),
                        GASContainer.init(type: .hollowTree, scene: self),
                        GASContainer.init(type: .wreckage, scene: self)]
        if random(2) == 1 {
            containers.append(possible[random(possible.count)])
            if let container = containers.first {
                var itemsCreated : Int = 0
                let weapons : [GASWeapon] = [GASWeapon.create(game: game, id: .wpnSword)]
                for _ in 0..<random(3) {
                    container.inventory.append(weapons[random(weapons.count)])
                    itemsCreated += 1
                }
                
                let armor : [GASArmor] = [GASArmor.create(game: game, id: .armShieldWooden)]
                for _ in 0..<random(3) {
                    container.inventory.append(armor[random(armor.count)])
                    itemsCreated += 1
                }
                
                if itemsCreated == 0 {
                    container.inventory.append(GASWeapon.create(game: game, id: .wpnSword))
                }
            }
        }
            //NSLog("Scene.generateContainers: Adding '\(containers[containers.count - 1])'")
    }
    
}
