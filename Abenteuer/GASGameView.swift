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
    
    let size : CGFloat
    let scale : CGFloat
    
    var parent : SKNode
    var view : SKShapeNode
    
    var game : GASGame!
    var scene : GASScene? {
        return game.scene
    }
    
    var spriteScene: SKSpriteNode?
    
    var imageForScene : SKSpriteNode? {
        var imageName : String
        
        switch(scene!.id) {
        case GASScene.keyScene01: imageName = "Scene01"
        case GASScene.keyScene02: imageName = "Scene02"
        case GASScene.keyScene03: imageName = "Scene03"
        case GASScene.keyScene04: imageName = "Scene04"
        default: NSLog("Error in GASGameView.imageForScene: missing case")
                 return nil
        }
        return SKSpriteNode(imageNamed: imageName)
    }
    
    
    init(game: GASGame, parent: SKNode, size: CGFloat, scale: CGFloat) {
        self.game = game
        self.parent = parent
        self.size = size
        self.scale = scale
        
        self.view = SKShapeNode(rectOf: CGSize(width: self.size, height: self.size))
        self.view.strokeColor = UIColor.clear
        self.parent.addChild(view)
    }
    
    func drawScene() {
        if let _ = self.scene {
            if let spriteScene = self.spriteScene {
                NSLog("drawScene: Removing old node.")
                spriteScene.removeFromParent()
            }
            
            if let image = imageForScene {
                view.addChild(image)
                image.scale(to: CGSize(width: size, height: size))
                image.name = "gameViewScene"
                image.position = CGPoint(x: 0, y: 0)
                spriteScene = image
                NSLog("drawScene: Adding new node.")
            } else {
                NSLog("Error in drawScene: No image found.")
            }
        }
    }
    
    

}
