//
//  GASSprite.swift
//  Abenteuer
//
//  Created by Christian Blomqvist on 2017-03-08.
//  Copyright © 2017 Christian Blomqvist. All rights reserved.
//

import Foundation
import SpriteKit

class GASSprite {
    var sprite : SKSpriteNode
    var parent : SKNode
    var name : String? {
        get {
            return sprite.name
        }
        set(value) {
            sprite.name = value
        }
    }
    
    var width : CGFloat {
        get {
            return sprite.size.width
        }
        set(value) {
            sprite.size.width = value
        }
    }
    var height : CGFloat {
        get {
            return sprite.size.height
        }
        set(value) {
            sprite.size.height = value
        }
    }
    
    private var offsetX : CGFloat {
        if let parent = self.parent as? SKSpriteNode {
            return -(parent.size.width / 2)
        } else {
            return 0
        }
    }
    private var offsetY : CGFloat {
        if let parent = self.parent as? SKSpriteNode {
            return (parent.size.height / 2) + (height / 2)
        } else {
            return 0
        }
    }
    
    var x : CGFloat {
        get {
            return offsetX + (sprite.position.x / scale)
        }
        set(value) {
            sprite.position.x = offsetX + (value * scale)
        }
    }
    var y : CGFloat {
        get {
            return offsetY + (sprite.position.y / scale)
        }
        set(value) {
            sprite.position.y = offsetY - (value * scale)
        }
    }
    var position : CGPoint {
        get {
            return CGPoint(x: x, y: y)
        }
        set(value) {
            x = value.x
            y = value.y
        }
    }
    var scale : CGFloat
    
    init(sprite: SKSpriteNode, parent: SKNode, scale: CGFloat = 1.0, name: String? = nil) {
        self.sprite = sprite
        self.parent = parent
        self.sprite.zPosition = self.parent.zPosition + 1
        self.scale = scale
        
        if name != nil {
            self.name = name
        }
        
        parent.addChild(self.sprite)
        position = CGPoint(x:0, y:0)
    }
}
