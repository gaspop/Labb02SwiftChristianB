//
//  GameView.swift
//  Abenteuer
//
//  Created by Christian Blomqvist on 2017-03-09.
//  Copyright © 2017 Christian Blomqvist. All rights reserved.
//

import Foundation
import SpriteKit

class GASGameView {
    
    let size : CGSize
    let scale : CGFloat
    
    let parent : GameScene
    var view : GASRectangle
    
    var game : GASGame {
        return parent.game
    }
    var scene : GASScene? {
        return game.scene
    }
    
    var spriteScene: GASSprite?
    var monsters : [GASSprite] = []
    
    var imageForScene : String? {
        switch(scene!.id) {
        case GASScene.keyScene01: return "Scene01"
        case GASScene.keyScene02: return "Scene02"
        case GASScene.keyScene03: return "Scene03"
        case GASScene.keyScene04: return "Test"
        default: NSLog("Error in GASGameView.imageForScene: missing case")
                 return nil
        }
    }
    
    
    init(parent: GameScene, size: CGSize, scale: CGFloat) {
        self.parent = parent
        self.size = size
        self.scale = scale
        
        self.view = GASRectangle(rectOf: size, radius: 0, color: nil, name: "poo", parent: self.parent, onTouch: nil)
    }
    
    func drawScene() {
        if let _ = self.scene {
            if let spriteScene = self.spriteScene {
                NSLog("drawScene: Removing old node.")
                spriteScene.removeFromParent()
            }
            spriteScene = GASSprite(imageNamed: imageForScene!, size: self.size, name: "gameViewScene", parent: self.view, onTouch: nil)
            NSLog("drawScene: Adding new node.")
            drawMonsters()
        }
    }
    
    func drawMonsters() {
        for m in monsters {
            m.removeFromParent()
        }
        
        monsters = []
        if let scene = scene {
            for m in scene.monsters {
                if m.isAlive {
                    var closure : (() -> Void)? = nil
                    closure = {
                        if let battle = self.game.battle,
                           let unit = battle.turnList.first,
                           unit.id == GASGame.playerId {
                            battle.setTarget(forUnit: unit, target: m)
                        }
                    }
                    let sprite = GASSprite(imageNamed: imageForMonster(m.type),
                                           size: CGSize(width: CGFloat(m.geometry.width) * scale,
                                                        height: CGFloat(m.geometry.height) * scale),
                                           name: nil, parent: self.view, onTouch: closure)
                    sprite.pivotMode = .bottomCenter
                    sprite.position(CGFloat(m.geometry.x) * scale, 960 * scale)
                    sprite.zPosition = self.view.zPosition + 1.0
                    monsters.append(sprite)
                }
            }
        }
    }

}

func imageForMonster(_ type: GASMonsterType) -> String {
    switch (type) {
    case .hoodlum: return "Jerk"
    default: return "Jerk"
    }
}
