//
//  GASTextBox.swift
//  Abenteuer
//
//  Created by Christian Blomqvist on 2017-03-19.
//  Copyright © 2017 Christian Blomqvist. All rights reserved.
//

import Foundation
import SpriteKit

class GASTextBox {
    
    let size : CGSize
    let padding : CGFloat
    var position : CGPoint {
        get {
            return container.position
        }
        set(value) {
            container.position = value
        }
     }
    
    let parent : SKNode
    private let container : GASRectangle
    private let textNode : SKMultilineLabel
    private let touchShape : GASRectangle?
    
    init(parent: SKNode, shape: GASRectangle, padding: CGFloat, font: UIFont, fontColor: UIColor, text: String, onTouch: (() -> Void)?) {
        self.parent = parent
        self.padding = padding
        self.textNode = SKMultilineLabel(text: text, labelWidth: Int(shape.size.width - (padding * 2)),
                                         pos: CGPoint(x: 0, y: 0), fontName: font.fontName, fontSize: font.pointSize,
                                         fontColor: fontColor, leading: nil, alignment: SKLabelHorizontalAlignmentMode.left,
                                         shouldShowBorder: false)
        self.size = CGSize(width: shape.size.width, height: CGFloat(textNode.labelHeight) + (padding * 2))
        self.container = GASRectangle(rectOf: self.size, radius: shape.cornerRadius, color: shape.fillColor,
                                      parent: self.parent, onTouch: nil)
        self.container.zPosition = self.parent.zPosition + 5.0
        self.container.addChild(textNode)
        self.textNode.zPosition = self.container.zPosition + 0.1
        self.textNode.position = CGPoint(x: container.size.width / 2, y: -(padding/1.5))
        if let onTouchClosure = onTouch {
            self.touchShape = GASRectangle(rectOf: self.size, radius: 0, color: UIColor.clear, parent: self.container, onTouch: onTouchClosure)
            self.touchShape!.zPosition = self.container.zPosition + 0.2
        } else {
            self.touchShape = nil
        }
    }
    
    func close() {
        if let touchShape = self.touchShape {
            touchShape.removeFromParent()
        }
        textNode.removeFromParent()
        container.removeFromParent()
    }
    
}
