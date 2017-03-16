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
    private let view : GASRectangle
    
    var position : CGPoint {
        get {
            return view.position
        }
        set(value) {
            view.position = value
        }
    }
    
    var game : GASGame {
        return parent.game
    }
    var scene : GASScene? {
        return game.scene
    }
    
    var sceneSprite: GASSprite?
    var monsterSprites : [GASSprite] = []
    
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
        
        self.view = GASRectangle(rectOf: size, radius: 0, color: nil, parent: self.parent, onTouch: nil)
    }
    
    func drawScene() {
        if let _ = self.scene {
            if let sceneSprite = self.sceneSprite {
                // NSLog("drawScene: Removing old node.")
                sceneSprite.removeFromParent()
            }
            sceneSprite = GASSprite(imageNamed: imageForScene!, size: self.size, parent: self.view, onTouch: nil)
            drawMonsters()
        }
    }
    
    func drawMonsters() {
        for m in monsterSprites {
            m.removeFromParent()
        }
        
        monsterSprites = []
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
                                           parent: self.view, onTouch: closure)

                    sprite.setPosition(CGFloat(m.geometry.x) * scale, 960 * scale)
                    sprite.zPosition = self.view.zPosition + 1.0
                    sprite.anchorPoint = CGPoint(x: 0.5, y: 0.0)
                    //print("anchor: \(sprite.anchorPoint)")
                    
                    
                    let action1 = SKAction.scaleY(to: 1.05, duration: 0.25)
                    let action2 = SKAction.scaleY(to: 0.95, duration: 0.25)
                    
                    func temp() {
                        sprite.run(action1, completion: { sprite.run(action2, completion: { temp() } ) } )
                    }
                    temp()
                    
                    monsterSprites.append(sprite)
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
