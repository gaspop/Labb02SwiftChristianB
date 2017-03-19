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
    
    var game : GASGame
    var type : GASSceneType
    var id : Int
    var monsters : [GASMonster] = []
    var containers : [GASContainer] = []
    private var _loot : GASContainer?
    var loot : GASContainer {
        if _loot == nil {
            _loot = GASContainer(type: .undefined, scene: self)
        }
        return _loot!
    }
    
    init(game: GASGame, type: GASSceneType) {
        self.game = game
        self.type = type
        self.game.sceneCount += 1
        self.id = game.sceneCount
        
        generateContainers()
        if self.game.sceneCount > 1 && random(2) == 1 {
            generateMonsters()
        }
    }
    
    
    func generateMonsters() {
        monsters = []
        let amount = random(4)
        for i in 0..<amount {
            let amount = Float(amount)
            let gap : Float = 288
            let space : Float = gap * (amount - 1)
            let startX = 512 - (space / 2)
            let monster = selectMonsterByLevel(level: game.player!.level)
            monster.geometry.x = startX + (gap * Float(i))
            monster.geometry.y = 1024
            monsters.append(monster)
        }
    }
    
    func selectMonsterByLevel(level: Int) -> GASMonster {
        let rnd = random(101)
        switch(level) {
        case 1...2:
            switch(rnd) {
            case 0...75:
                return GASMonster.create(game: game, type: .idiot)
            case 76...95:
                return GASMonster.create(game: game, type: .thug)
            case 96...99:
                return GASMonster.create(game: game, type: .spider)
            default:
                return selectMonsterRandomly()
            }
        
        case 3...4:
            switch(rnd) {
            case 0...20:
                return GASMonster.create(game: game, type: .idiot)
            case 21...55:
                return GASMonster.create(game: game, type: .thug)
            case 56...85:
                return GASMonster.create(game: game, type: .jerk)
            case 81...99:
                return GASMonster.create(game: game, type: .spider)
            default:
                return GASMonster.create(game: game, type: .slime)
            }
        case 5...6:
            switch(rnd) {
            case 0...5:
                return GASMonster.create(game: game, type: .idiot)
            case 6...15:
                return GASMonster.create(game: game, type: .thug)
            case 16...40:
                return GASMonster.create(game: game, type: .jerk)
            case 41...70:
                return GASMonster.create(game: game, type: .spider)
            case 71...90:
                return GASMonster.create(game: game, type: .slime)
            default:
                return GASMonster.create(game: game, type: .duck)
            }
        case 7...10:
            switch(rnd) {
            case 0...5:
                return GASMonster.create(game: game, type: .thug)
            case 6...15:
                return GASMonster.create(game: game, type: .jerk)
            case 16...30:
                return GASMonster.create(game: game, type: .spider)
            case 31...50:
                return GASMonster.create(game: game, type: .slime)
            default:
                return GASMonster.create(game: game, type: .duck)
            }
        default:
            return selectMonsterRandomly()
        }
    }
        
    func selectMonsterRandomly() -> GASMonster {
        let rnd = random(6)
        switch(rnd) {
        case 0:
            return GASMonster.create(game: game, type: .idiot)
        case 1:
            return GASMonster.create(game: game, type: .thug)
        case 2:
            return GASMonster.create(game: game, type: .jerk)
        case 3:
            return GASMonster.create(game: game, type: .spider)
        case 4:
            return GASMonster.create(game: game, type: .slime)
        case 5:
            return GASMonster.create(game: game, type: .duck)
        default:
            return GASMonster.create(game: game, type: .idiot)
        }
    }
    
    func gatherLoot() {
        for m in monsters {
            if !m.isAlive {
                let rndCount = min(3, m.inventory.count)
                for _ in 0..<rndCount {
                    let rndIndex = random(m.inventory.count)
                    loot.inventory.append(m.inventory[rndIndex])
                    m.inventory.remove(at: rndIndex)
                }
            }
        }
    }
    
    func describeScene() -> String {
        var message = descriptionForSceneType(type)
        if containers.count > 0 {
            message += " There is a mysterious looking \(stringForContainer(containers.first!.type)) here."
        }
        return message
    }
    
    func generateContainers() {
        containers = []
        let possible = [GASContainer.init(type: .chest, scene: self)]
        if random(4) == 1 {
            containers.append(possible[random(possible.count)])
            if let container = containers.first {
                var itemsCreated : Int = 0
                if random(5) == 1 {
                    let weapons : [GASWeapon] = [GASWeapon.create(game: game, id: .wpnSword),
                                                 GASWeapon.create(game: game, id: .wpnBat),
                                                 GASWeapon.create(game: game, id: .wpnAxe)]
                    for _ in 0..<random(3) {
                        container.inventory.append(weapons[random(weapons.count)])
                        itemsCreated += 1
                    }
                }
                
                if random(5) == 1 {
                    let armor : [GASArmor] = [GASArmor.create(game: game, id: .armShieldWooden),
                                              GASArmor.create(game: game, id: .armShieldSteel)]
                    for _ in 0..<random(3) {
                        container.inventory.append(armor[random(armor.count)])
                        itemsCreated += 1
                    }
                }
                
                if random(3) == 1 {
                    let treasure : [GASTreasure] = [GASTreasure.create(game: game, id: .treGoldCoin),
                                                    GASTreasure.create(game: game, id: .treNecklace),
                                                    GASTreasure.create(game: game, id: .treJewel)]
                    for _ in 0..<random(3) {
                        container.inventory.append(treasure[random(treasure.count)])
                        itemsCreated += 1
                    }
                }
                
                if random(2) == 1 {
                    let consumable : [GASConsumable] = [GASConsumable.create(game: game, id: .conFoodBread),
                                                        GASConsumable.create(game: game, id: .conPotion)]
                    for _ in 0..<random(3) {
                        container.inventory.append(consumable[random(consumable.count)])
                        itemsCreated += 1
                    }
                }
                
                if itemsCreated == 0 {
                    container.inventory.append(GASConsumable.create(game: game, id: .conPotion))
                }
            }
        }
    }
    
}


enum GASSceneType {
    case field
    case forestOutside
    case forestInside
    case hills
}

func descriptionForSceneType(_ type: GASSceneType) -> String {
    switch(type) {
    case .field:
        return "You are standing in a large field, in the distance you can see a forest."
    case .forestOutside:
        return "You find yourself outside a deep dark forest."
    case .forestInside:
        return "You are on a path through a forest. There is a small clearing ahead."
    case .hills:
        return "You are walking through the hills. In the distance you can see a mountain range."
    }
}


