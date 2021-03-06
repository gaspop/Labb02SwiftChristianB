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
    
    var onTouchClosure : ((Void) -> Void)?
    
    var width : CGFloat {
        get {
            return self.size.width
        }
        set(value) {
            self.size = CGSize(width: value, height: self.size.height)
        }
    }
    var height : CGFloat {
        get {
            return self.size.height
        }
        set(value) {
            self.size = CGSize(width: self.size.width, height: value)
        }
    }
    
    override var position: CGPoint {
        get {
            return super.position
        }
        set(value) {
            super.position = CGPoint(x: value.x, y: -value.y)
        }
    }
    
    var x : CGFloat {
        get {
            return self.position.x
        }
        set(value) {
            super.position = CGPoint(x: value, y: self.y)
        }
    }
    var y : CGFloat {
        get {
            return self.position.y
        }
        set(value) {
            super.position = CGPoint(x: self.x, y: -value)
        }
    }
    
    func setPosition(_ x: CGFloat, _ y: CGFloat) {
        self.x = x
        self.y = y
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let closure = onTouchClosure {
            closure()
        }
    }

    init(imageNamed: String, size: CGSize?, parent: SKNode?, onTouch: (() -> Void)?) {
        let texture = SKTexture(imageNamed: imageNamed)
        var useSize = texture.size()
        if let size = size {
            useSize = size
        }
        super.init(texture: texture, color: UIColor.clear, size: useSize)
        
        if let parent = parent {
            parent.addChild(self)
        }
        
        self.anchorPoint = GASPivot.topLeft
        self.position = CGPoint(x: 0, y: 0)
        
        if let closure = onTouch {
            onTouchClosure = closure
            isUserInteractionEnabled = true
        } else {
            isUserInteractionEnabled = false
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
