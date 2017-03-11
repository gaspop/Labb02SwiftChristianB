//
//  GASSprite.swift
//  Abenteuer
//
//  Created by Christian Blomqvist on 2017-03-08.
//  Copyright © 2017 Christian Blomqvist. All rights reserved.
//

import Foundation
import SpriteKit

class GASSprite : SKSpriteNode {
    
    var width : CGFloat {
        get {
            return self.size.width
        }
        set(value) {
            self.size.width = value
        }
    }
    var height : CGFloat {
        get {
            return self.size.height
        }
        set(value) {
            self.size.height = value
        }
    }
    
    private var offsetX : CGFloat {
        if let parent = self.parent as? SKSpriteNode {
            return -(parent.size.width / 2) + (width / 2)
        } else if let parent = self.parent as? SKScene {
            return -(parent.size.width / 2) + (width / 2)
        }else {
            return (width / 2)
        }
    }
    private var offsetY : CGFloat {
        if let parent = self.parent as? SKSpriteNode {
            return (parent.size.height / 2) - (height / 2)
        } else if let parent = self.parent as? SKScene {
            return (parent.size.height / 2) - (height / 2)
        }else {
            return -(height / 2)
        }
    }
    
    var x : CGFloat {
        get {
            return offsetX + self.position.x
        }
        set(value) {
            self.position.x = offsetX + value
        }
    }
    var y : CGFloat {
        get {
            return offsetY + self.position.y
        }
        set(value) {
            self.position.y = offsetY - value
        }
    }
    /*
    override var position : CGPoint {
        get {
            return CGPoint(x: x, y: y)
        }
        didSet(value) {
            self.position.x = 0
            self.position.y = 0
            //self.position = value
        }
    }
    */
    func position(_ x: CGFloat, _ y: CGFloat) {
        self.x = x
        self.y = y
    }
    
/*
    init(image: String) {
        super.init(imageNamed: image)
        //SKSpriteNode(imageNamed: )
    }
 */
    
    //var scale : CGFloat
    
    /*
    init(sprite: SKSpriteNode, scale: CGFloat = 1.0, name: String? = nil) {
        self.sprite = sprite
        self.sprite.zPosition = self.parent.zPosition + 1
        self.scale = scale
        
        if name != nil {
            self.name = name
        }
        
        parent.addChild(self.sprite)
        position = CGPoint(x:0, y:0)
    }
    */
}
