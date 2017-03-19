//
//  GASButton.swift
//  Abenteuer
//
//  Created by Christian Blomqvist on 2017-03-09.
//  Copyright © 2017 Christian Blomqvist. All rights reserved.
//

import Foundation
import SpriteKit

class GASButton {
    
    let size : CGSize
    var position : CGPoint {
        get {
            return container.position
        }
        set(value) {
            container.position = value
        }
    }
    
    private let container : GASRectangle
    private let shape : GASRectangle
    private let touchShape : GASRectangle?
    var sprite : GASSprite?

    var textColor : UIColor?
    var font : UIFont?
    var onTouchClosure : (() -> Void)?
    private var label : SKLabelNode?
    var labelText : String? {
        get {
            if let label = self.label {
                return label.text
            } else {
                return nil
            }
        }
        set(value) {
            if let label = self.label {
                label.removeFromParent()
            }
            label = nil
            label = SKLabelNode()
            if let label = self.label {
                if let font = font {
                    label.fontName = font.fontName
                    label.fontSize = font.pointSize
                } else {
                    label.fontName = "Helvetica"
                    label.fontSize = 10
                }
                if let textColor = textColor {
                    label.color = textColor
                } else {
                    label.color = UIColor.white
                }
                label.text = value
                label.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
                label.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
                shape.addChild(label)
                label.zPosition = label.parent!.zPosition + 0.2
            }
        }
    }
    
    init(parent: SKNode, shape: GASRectangle, sprite: GASSprite?, text: String?, textColor: UIColor?, font: UIFont?, onTouch: (() -> Void)?) {
        self.size = CGSize(width: shape.frame.width, height: shape.frame.height)
        self.container = GASRectangle(rectOf: shape.size, radius: 0, color: UIColor.clear, parent: parent, onTouch: nil)
        self.container.zPosition = parent.zPosition + 0.1
        self.shape = GASRectangle(rectOf: shape.size, radius: shape.cornerRadius, color: shape.fillColor, parent: container, onTouch: nil)
        self.shape.zPosition = parent.zPosition + 0.1
        self.shape.anchorPoint = GASPivot.center
        self.shape.position = CGPoint(x: size.width / 2, y: size.height / 2)

        
        if let sprite = sprite {
            let maxLength = max(sprite.size.width, sprite.size.height)
            let minShapeSide = min(size.width, size.height)
            let scale = minShapeSide / maxLength
            self.shape.addChild(sprite)
            sprite.anchorPoint = GASPivot.center
            sprite.size = CGSize(width: sprite.size.width * scale * 1.0, height: sprite.size.height * scale * 1.0)
            sprite.zPosition = sprite.parent!.zPosition + 0.1
        }
        
        if let closure = onTouch {
            self.touchShape = GASRectangle(rectOf: self.size, radius: 0, color: UIColor.clear, parent: self.shape, onTouch: nil)
            self.touchShape!.zPosition = touchShape!.parent!.zPosition + 0.3
            self.touchShape!.anchorPoint = GASPivot.center
            self.onTouchClosure = {
                if UserInteraction.isEnabled {
                    UserInteraction.isEnabled = false
                    self.shape.run(SKAction.scale(to: 0.9, duration: 0.1), completion: {
                        self.shape.run(SKAction.scale(to: 1.0, duration: 0.1), completion: {
                            closure()
                            UserInteraction.isEnabled = true
                        })
                    })
                }
            }
            self.touchShape!.onTouchClosure = self.onTouchClosure
            self.touchShape!.isUserInteractionEnabled = true
        } else {
            touchShape = nil
        }
        
        if let font = font {
            self.font = font
        }
        
        if let text = text {
            labelText = text
        }

    }
    
    func setPosition(_ x: CGFloat, _ y: CGFloat) {
        position = CGPoint(x: x, y: y)
    }
    
    func clear() {
        for c in self.container.children {
            c.removeAllActions()
            c.removeAllChildren()
        }
        self.container.removeAllActions()
        self.container.removeFromParent()
    }
    
}
