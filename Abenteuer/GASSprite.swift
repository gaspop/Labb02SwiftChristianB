//
//  GASSprite.swift
//  Abenteuer
//
//  Created by Christian Blomqvist on 2017-03-08.
//  Copyright © 2017 Christian Blomqvist. All rights reserved.
//

import Foundation
import SpriteKit

class GASSprite : SKSpriteNode, GASNodeProtocol {
    
    var onTouchClosure : ((Void) -> Void)?
    
    var width : CGFloat {
        get {
            return self.size.width
        }
        set(value) {
            self.size(value, height)
        }
    }
    var height : CGFloat {
        get {
            return self.size.height
        }
        set(value) {
            self.size(width, value)
        }
    }
    
    func size(_ width: CGFloat, _ height: CGFloat) {
        self.size = CGSize(width: width, height: height)
    }
    
    private var _pivotMode : GASNodePivot = .topLeft
    var pivotMode : GASNodePivot {
        get {
            return _pivotMode
        }
        set(value) {
            _pivotMode = value
            position(x,y)
        }
    }
    
    private var offsetX : CGFloat {
        var x : CGFloat = 0
        switch(pivotMode) {
        case .topLeft:      x = (width / 2)
        case .bottomCenter: x = 0
        default:            x = 0
        }
        
        if let parent = self.parent as? SKScene {
            return -(parent.size.width / 2) + x
        } else if let parent = self.parent as? GASNodeProtocol {
            return -(parent.width / 2) + x
        }else {
            return x
        }
    }
    private var offsetY : CGFloat {
        var y : CGFloat = 0
        switch(pivotMode) {
        case .topLeft:      y = -(height / 2)
        case .bottomCenter: y = (height / 2)
        default:            y = 0
        }
        
        if let parent = self.parent as? SKScene {
            return (parent.size.height / 2) + y
        } else if let parent = self.parent as? GASNodeProtocol {
            return (parent.height / 2) + y
        }else {
            return y
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
    
    func position(_ x: CGFloat, _ y: CGFloat) {
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
        position(0,0)
        
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
