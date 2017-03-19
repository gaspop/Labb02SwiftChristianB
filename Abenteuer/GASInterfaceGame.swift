//
//  GASInterfaceGame.swift
//  Abenteuer
//
//  Created by Christian Blomqvist on 2017-03-18.
//  Copyright © 2017 Christian Blomqvist. All rights reserved.
//

import Foundation
import SpriteKit

class GASInterfaceGame {
    
    let gameViewMaxSize : CGFloat = 1024
    let gameViewScreenShare : CGFloat = 0.45
    let buttonMaxHeight : CGFloat = 128
    let buttonMaxSpacing : CGFloat = 64
    
    let optionMoveTime : Double = 0.25
    let zPosition : CGFloat = 1.0
    
    let parent : GameScene
    
    let gameView : GASGameView
    let gameViewSize : CGFloat
    let gameViewScale : CGFloat
    let gameViewMargin : CGFloat
    
    var game : GASGame {
        return parent.game
    }
    
    var optionViewOffsetX : CGFloat {
        return gameViewMargin
    }
    var optionViewOffsetY : CGFloat {
        return gameViewMargin * 2 + gameViewSize
    }
    var optionHeight : CGFloat {
        return 128 * gameViewScale
    }
    var optionSpacing : CGFloat {
        return buttonMaxSpacing * gameViewScale
    }
    
    private var optionView : GASOptionView?
    
    
    init(parent: GameScene) {
        self.parent = parent
        self.gameViewSize = parent.size.height * gameViewScreenShare
        self.gameViewScale = gameViewSize / gameViewMaxSize
        self.gameViewMargin = (parent.size.width - gameViewSize) / 2
        
        self.gameView = GASGameView(parent: parent,
                                    size: CGSize(width: gameViewSize, height: gameViewSize), scale: gameViewScale)
        self.gameView.position = CGPoint(x: gameViewMargin, y: gameViewMargin)
    }
    
    func displayOptions(_ options: [GASOptionViewData]) {
        if let lastOptionView = self.optionView {
            UserInteraction.isEnabled = false
            lastOptionView.animate(action: SKAction.moveTo(x: -lastOptionView.size.width, duration: optionMoveTime), completion: {
                lastOptionView.close()
            })
        }
        let font = UIFont(name: "Helvetica", size: 64 * gameViewScale)
        self.optionView = GASOptionView(parent: parent,
                                        zPosition: 1.0,
                                        optionWidth: gameViewSize,
                                        optionHeight: optionHeight,
                                        optionSpacing: optionSpacing,
                                        optionFont: font,
                                        options: options )
        
        if let optionView = self.optionView {
            optionView.position = CGPoint(x: parent.size.width, y: optionViewOffsetY)
            optionView.animate(action: SKAction.moveTo(x: optionViewOffsetX, duration: optionMoveTime), completion: {
                UserInteraction.isEnabled = true
            })
        }
    }
    
    func generatePlayerOptions() {
        
        var options : [GASOptionViewData] = []
        
        if let scene = game.scene {
            if let battle = game.battle {
                options.append(GASOptionViewData(text: "Attack!", closure: {
                    GASEvent.finish()
                    battle.takeTurn()
                } ))
            }
            else {
                if scene.paths.count > 0 {
                    NSLog("Travel option!")
                    options.append(GASOptionViewData(text: "Travel onwards", closure: {
                        GASEvent.finish()
                        self.game.newScene()
                    }))
                }
                if scene.loot.inventory.count > 0 {
                    options.append(GASOptionViewData(text: "Gather loot", closure: {
                        self.optionView!.close()
                        self.parent.inventoryInterface.generateInventory(container: scene.loot)
                        self.parent.inventoryInterface.generateInventoryOptions()
                        GASEvent.insert(GASGameEvent(.showLoot, hold: true))
                    }))
                }
                if let container = scene.containers.first,
                    container.inventory.count > 0 {
                    options.append(GASOptionViewData(text: "Search \(stringForContainer(container.type))", closure: {
                        self.optionView!.close()
                        self.parent.inventoryInterface.generateInventory(container: container)
                        self.parent.inventoryInterface.generateInventoryOptions()
                        GASEvent.insert(GASGameEvent(.showContainer, hold: true))
                    }))
                }
            }
            options.append(GASOptionViewData(text: "Inventory", closure: {
                self.optionView!.close()
                self.parent.inventoryInterface.generatePlayerInventory()
                self.parent.inventoryInterface.generatePlayerInventoryOptions()
            }))
        }
        displayOptions(options)
        
    }
    
    func generatePauseOptions() {
        var options : [GASOptionViewData] = []
        options.append(GASOptionViewData(text: "Continue", closure: {
            GASEvent.finish()
            self.game.battle!.takeTurn()
        } ))
        displayOptions(options)
    }
    
}
