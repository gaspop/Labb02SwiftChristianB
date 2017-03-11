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
    
    var size : CGSize
    var shape : GASRectangle
    var sprite : GASSprite?
    var text : String?
    var textColor : UIColor?
    var font : UIFont?
    var id : String?
    
    init(parent: SKNode, identifier: String?, size: CGSize, shape: GASRectangle, sprite: GASSprite?, text: String?, textColor: UIColor?, font: UIFont?) {
        self.size = size
        self.shape = shape
        parent.addChild(self.shape)
        self.shape.zPosition = parent.zPosition + 0.1
        
        if let sprite = sprite {
            let maxLength = max(sprite.size.width, sprite.size.height)
            let minShapeSide = min(size.width, size.height)
            let scale = minShapeSide / maxLength
            sprite.size = CGSize(width: sprite.size.width * scale * 1.0, height: sprite.size.height * scale * 1.0)
            shape.addChild(sprite)
            sprite.zPosition = sprite.parent!.zPosition + 0.1
        }
        
        if let text = text {
            self.text = text
            let label = SKLabelNode()
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
            label.text = text
            label.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
            label.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
            shape.addChild(label)
            label.zPosition = label.parent!.zPosition + 0.2
        }
        
        if let identifier = identifier {
            let touchShape = GASRectangle(rectOf: self.size, radius: 0, color: UIColor.clear, name: identifier, parent: shape)
            touchShape.zPosition = touchShape.parent!.zPosition + 0.3
            self.id = identifier
        }
    }
    
    func position(_ x: CGFloat, _ y: CGFloat) {
        shape.position(x, y)
/*        var parentSize : CGSize
        if let parent = shape.parent! as? SKScene {
            parentSize = parent.size
        } else {
            parentSize = CGSize(width: 0, height: 0)
        }
        shape.position = CGPoint(x: -(parentSize.width / 2) + (size.width / 2) + at.x,
                                 y: (parentSize.height / 2) - (size.height / 2) - at.y)*/
    }
    
}
