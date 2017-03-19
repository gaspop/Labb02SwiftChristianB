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
    var monsterSprites : [GASGameMonsterView] = []
    
    var imageForScene : String {
        switch(scene!.type) {
        case .forestInside:
            return "sceneBackground01"
        case .field:
            return "sceneBackground02"
        case .forestOutside:
            return "sceneBackground03"
        case .hills:
            return "sceneBackground04"
            /*
        default: NSLog("Error in GASGameView.imageForScene: missing case")
                 return nil*/
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
            sceneSprite = GASSprite(imageNamed: imageForScene, size: self.size, parent: self.view, onTouch: nil)
            drawMonsters()
        }
    }
    
    func clearMonsters() {
        for m in monsterSprites {
            m.clear()
        }
    }
    
    func drawMonsters() {
        clearMonsters()
        monsterSprites = []
        if let scene = scene,
           let sceneSprite = sceneSprite {
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
                    let view = GASGameMonsterView(parent: sceneSprite, source: m, scale: self.scale, onTouch: closure)
                    monsterSprites.append(view)
                }
            }
        }
    }
    
    func close() {
        clearMonsters()
        self.view.removeAllChildren()
        self.view.removeFromParent()
    }

}

