//
//  GASRect.swift
//  Abenteuer
//
//  Created by Christian Blomqvist on 2017-03-11.
//  Copyright © 2017 Christian Blomqvist. All rights reserved.
//

import UIKit
import SpriteKit

class GASRectangle : SKShapeNode, GASNode {

    var cornerRadius : CGFloat
    private var size : CGSize
    
    func size(_ width: CGFloat, _ height: CGFloat) {
        self.size = CGSize(width: width, height: height)
        let rectOrigin = CGPoint(x: -(width / 2), y: -(height / 2))
        let rect = CGRect(origin: rectOrigin, size: size)
        self.path = CGPath(roundedRect: rect, cornerWidth: cornerRadius, cornerHeight: cornerRadius, transform: nil)
    }
    
    var width : CGFloat {
        get {
            return self.size.width
        }
        set(value) {
            self.size(value, height)
            //self.size.width = value
        }
    }
    var height : CGFloat {
        get {
            return self.size.height
        }
        set(value) {
            self.size(width, value)
            //self.size.height = value
        }
    }
    
    private var offsetX : CGFloat {
        if let parent = self.parent as? SKScene {
            return parent.size.width / 2
        } else if let parent = self.parent as? GASNode {
            return parent.width / 2
        }else {
            return (width / 2)
        }
    }
    private var offsetY : CGFloat {
        if let parent = self.parent as? SKScene {
            return (parent.size.height / 2) - (height / 2)
        } else if let parent = self.parent as? GASNode {
            return (parent.height / 2) - (height / 2)
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

    func position(_ x: CGFloat, _ y: CGFloat) {
        self.x = x
        self.y = y
    }
    
    init(rectOf: CGSize, radius: CGFloat, color: UIColor?, name: String?) {
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
        self.lineWidth = 1
        self.glowWidth = 0
        if let name = name {
            self.name = name
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        size = CGSize(width: 0, height: 0)
        cornerRadius = 0
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
}
