//
//  GASGameMonsterView.swift
//  Abenteuer
//
//  Created by Christian Blomqvist on 2017-03-19.
//  Copyright © 2017 Christian Blomqvist. All rights reserved.
//

import Foundation
import SpriteKit

class GASGameMonsterView {
    
    let size : CGSize
    let scale : CGFloat
    let parent : SKNode
    let sprite : GASSprite
    let source : GASMonster
    
    init(parent: SKNode, source: GASMonster, scale: CGFloat, onTouch: (() -> Void)?) {
        self.parent = parent
        self.source = source
        self.scale = scale
        let distanceScale = 0.25 + (0.75 * (CGFloat(source.geometry.y) / 1024))
        self.size = CGSize(width: CGFloat(source.geometry.width) * distanceScale * scale,
                           height: CGFloat(source.geometry.height) * distanceScale * scale)
        self.sprite = GASSprite(imageNamed: imageForMonster(source.type),
                                size: size, parent: parent, onTouch: onTouch)
        self.sprite.anchorPoint = GASPivot.bottomCenter
        self.sprite.zPosition = self.sprite.parent!.zPosition + 0.1
        
        self.sprite.position = CGPoint(x: CGFloat(source.geometry.x) * scale,
                                       y: (704 + (320 - 32) * (CGFloat(source.geometry.y) / 1024)) * scale)
        self.animateIdle()
    }
    
    func clear() {
        self.sprite.removeAllActions()
        self.sprite.removeFromParent()
    }
    
    func animateIdle() {
        self.sprite.run(SKAction.scaleY(to: 1.05, duration: 0.25), completion: {
            self.sprite.run(SKAction.scaleY(to: 0.95, duration: 0.25), completion: {
                self.animateIdle()
            } )
        } )
    }
}


func imageForMonster(_ type: GASMonsterType) -> String {
    switch (type) {
    case .idiot:
        return "monsterIdiot"
    case .thug:
        return "monsterThug"
    case .jerk:
        return "monsterJerk"
    case .spider:
        return "monsterSpider"
    case .slime:
        return "monsterSlime"
    case .duck:
        return "monsterDuck"
        //default: return ""
    }
}
