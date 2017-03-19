//
//  GASRect.swift
//  Abenteuer
//
//  Created by Christian Blomqvist on 2017-03-11.
//  Copyright © 2017 Christian Blomqvist. All rights reserved.
//

import UIKit
import SpriteKit

class GASRectangle : SKShapeNode {

    var onTouchClosure : ((Void) -> Void)?
    let cornerRadius : CGFloat
    
    let size : CGSize
    
    var width : CGFloat {
        get {
            return self.size.width
        }
    }
    var height : CGFloat {
        get {
            return self.size.height
        }
    }
    
    private var lastOriginX : CGFloat = 0.0
    private var lastOriginY : CGFloat = 0.0
    private var _anchorPoint : CGPoint = CGPoint(x: 0.0, y: 0.0)
    var anchorPoint : CGPoint {
        get {
            return _anchorPoint
        }
        set(value) {
            _anchorPoint = CGPoint(x: max(0.0, min(value.x, 1.0)), y: max(0.0, min(value.y, 1.0)))
            let rect = CGRect(x: -(width * _anchorPoint.x), y: -(height * _anchorPoint.y),
                              width: width, height: height)
            let differenceX = rect.origin.x - lastOriginX
            let differenceY = rect.origin.y - lastOriginY
            self.path = CGPath(rect: rect, transform: nil)
            for c in self.children {
                c.position = CGPoint(x: c.position.x + differenceX, y: c.position.y + differenceY)
            }
            lastOriginX = rect.origin.x
            lastOriginY = rect.origin.y
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
    
    init(rectOf: CGSize, radius: CGFloat, color: UIColor?, parent: SKNode?, onTouch: (() -> Void)?) {
        size = rectOf
        cornerRadius = radius
        super.init()
        
        let rectOrigin = CGPoint(x: -(rectOf.width / 2), y: -(rectOf.height / 2))
        let rect = CGRect(origin: rectOrigin, size: rectOf)
        self.path = CGPath(roundedRect: rect, cornerWidth: cornerRadius, cornerHeight: cornerRadius, transform: nil)
        self.alpha = 1.0
        if let color = color {
            self.fillColor = color
            self.strokeColor = color
        } else {
            self.fillColor = UIColor.white
            self.strokeColor = UIColor.white
        }
        self.lineWidth = 0
        self.glowWidth = 0
        
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
        size = CGSize(width: 0, height: 0)
        cornerRadius = 0
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
}
