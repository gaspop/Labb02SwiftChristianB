//
//  GASOptionView.swift
//  Abenteuer
//
//  Created by Christian Blomqvist on 2017-03-18.
//  Copyright © 2017 Christian Blomqvist. All rights reserved.
//

import Foundation
import SpriteKit

class GASOptionViewData {
    
    let text : String
    let closure : (() -> Void)
    
    init(text: String, closure: @escaping (() -> Void)) {
        self.text = text
        self.closure = closure
    }
    
}

class GASOptionView {
    
    let size : CGSize
    let zPosition : CGFloat
    
    let parent : GameScene
    private let optionWidth : CGFloat
    private let optionHeight : CGFloat
    private let optionSpacing : CGFloat
    
    private let view : GASRectangle
    private let options : [GASButton]
    
    var position : CGPoint {
        get {
            return self.view.position
        }
        set(value) {
            self.view.position = value
        }
    }
    
    init(parent: GameScene, zPosition: CGFloat, optionWidth: CGFloat, optionHeight: CGFloat,
         optionSpacing: CGFloat, optionFont: UIFont?, options: [GASOptionViewData]) {
        self.parent = parent
        self.optionWidth = optionWidth
        self.optionHeight = optionHeight
        self.optionSpacing = optionSpacing
        self.size = CGSize(width: optionWidth,
                           height: (optionHeight + optionSpacing) * CGFloat(options.count) - optionSpacing)
        self.zPosition = zPosition
        self.view = GASRectangle(rectOf: self.size, radius: 0, color: UIColor.clear, parent: self.parent, onTouch: nil)
        self.view.zPosition = self.zPosition
        
        var buttons : [GASButton] = []
        for (i,o) in options.enumerated() {
            let shape = GASRectangle(rectOf: CGSize(width: optionWidth, height: optionHeight), radius: 4, color: UIColor.brown, parent: nil, onTouch: nil)
            let button = GASButton(parent: self.view, shape: shape, sprite: nil, text: o.text, textColor: nil, font: optionFont, onTouch: o.closure)
            button.position = CGPoint(x: 0, y: (optionHeight + optionSpacing) * CGFloat(i))
            buttons.append(button)
        }
        self.options = buttons
        //NSLog("GASOptionView.init: With \(options.count) buttons.")
    }
    
    func close() {
        for o in options {
            o.clear()
        }
        self.view.removeAllActions()
        self.view.removeFromParent()
    }
    
    func animate(action: SKAction, completion: (() -> Void)?) {
        view.run(action) {
            if let completion = completion {
                completion()
            }
        }
    }
    
}
