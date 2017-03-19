//
//  GASInterfaceInventory.swift
//  Abenteuer
//
//  Created by Christian Blomqvist on 2017-03-19.
//  Copyright © 2017 Christian Blomqvist. All rights reserved.
//

import Foundation
import SpriteKit

class GASInterfaceInventory {
    
    let inventoryViewMaxSize : CGFloat = 1024
    let inventoryViewScreenShare : CGFloat = 0.45
    let buttonMaxHeight : CGFloat = 128
    let buttonMaxSpacing : CGFloat = 64
    
    let optionMoveTime : Double = 0.25
    let zPosition : CGFloat = 2.0
    
    let parent : GameScene
    
    private var optionView : GASOptionView?

    var inventoryView : GASInventoryView?
    let inventoryViewSize : CGFloat
    let inventoryViewScale : CGFloat
    let inventoryViewMargin : CGFloat
    
    var game : GASGame {
        return parent.game
    }
    
    var optionViewOffsetX : CGFloat {
        return inventoryViewMargin
    }
    var optionViewOffsetY : CGFloat {
        return inventoryViewMargin * 2 + inventoryViewSize
    }
    var optionHeight : CGFloat {
        return 128 * inventoryViewScale
    }
    var optionSpacing : CGFloat {
        return buttonMaxSpacing * inventoryViewScale
    }
    
    
    init(parent: GameScene) {
        self.parent = parent
        self.inventoryViewSize = parent.size.height * inventoryViewScreenShare
        self.inventoryViewScale = inventoryViewSize / inventoryViewMaxSize
        self.inventoryViewMargin = (parent.size.width - inventoryViewSize) / 2
        
        /*
        self.inventoryView = GASInventoryView(parent: parent, source: source, rows: 6, columns: 6, size: inventoryViewSize, scale: inventoryViewScale, onItemTouch: { _ in } )
        
        self.inventoryView.position = CGPoint(x: inventoryViewMargin, y: inventoryViewMargin)
        */
    }
    
    func displayOptions(_ options: [GASOptionViewData]) {
        clearInventoryOptions()
        
        let font = UIFont(name: "Helvetica", size: 64 * inventoryViewScale)
        self.optionView = GASOptionView(parent: parent,
                                        zPosition: 2.0,
                                        optionWidth: inventoryViewSize,
                                        optionHeight: optionHeight,
                                        optionSpacing: optionSpacing,
                                        optionFont: font,
                                        options: options )
        self.optionView!.position = CGPoint(x: optionViewOffsetX, y: optionViewOffsetY)
        UserInteraction.isEnabled = true

    }

    
    func clearInventoryView() {
        if let inventoryView = self.inventoryView {
            inventoryView.close()
            self.inventoryView = nil
        }
    }
    
    func clearInventoryOptions() {
        if let optionView = self.optionView {
            optionView.close()
        }
        self.optionView = nil
    }
    
    func generatePlayerInventory() {
        clearInventoryView()
        GASEvent.insert(GASGameEvent(.showInventory, hold: true))
        if let player = game.player {
            self.inventoryView = GASInventoryView(parent: self.parent,
                                                  source: player,
                                                  rows: 5, columns: 5, size: inventoryViewSize, scale: inventoryViewScale,
                                                  onItemTouch: {
                                                    item in
                                                    self.inventoryView!.selected = item
                                                    self.generatePlayerInventoryOptions()
                                                    
            })
            self.inventoryView!.position = CGPoint(x: inventoryViewMargin, y: inventoryViewMargin)
            self.inventoryView!.draw()
            self.generatePlayerInventoryOptions()
        }
    }
    
    
    func generatePlayerInventoryOptions() {
        clearInventoryOptions()
        var options : [GASOptionViewData] = []
        
        func deselectAndUpdate() {
            self.inventoryView!.selected = nil
            self.generatePlayerInventoryOptions()
        }
        
        if let player = game.player,
            let item = inventoryView?.selected {
            var isSelectedWeaponId = false
            var isSelectedArmorId = false
            
            if let item = item as? GASWeapon {
                if let current = player.weapon,
                    current.id == item.id {
                    isSelectedWeaponId = true
                    options.append(GASOptionViewData(text: "Remove", closure: {
                        player.weapon = nil
                        deselectAndUpdate()
                    }))
                } else {
                    options.append(GASOptionViewData(text: "Equip", closure: {
                        player.weapon = item
                        deselectAndUpdate()
                    }))
                }
            } else if let item = item as? GASArmor {
                if let current = player.armor,
                    current.id == item.id {
                    isSelectedArmorId = true
                    options.append(GASOptionViewData(text: "Remove", closure: {
                        player.armor = nil
                        deselectAndUpdate()
                    }))
                } else {
                    options.append(GASOptionViewData(text: "Equip", closure: {
                        player.armor = item
                        deselectAndUpdate()
                    }))
                }
            }
            options.append(GASOptionViewData(text: "Drop item", closure: {
                self.game.scene!.loot.inventory.append(item)
                if let index = player.inventory.index(where:  { $0.id == item.id } ) {
                    player.inventory.remove(at: index)
                }
                if isSelectedWeaponId {
                    player.weapon = nil
                }
                if isSelectedArmorId {
                    player.armor = nil
                }
                self.inventoryView!.update()
                deselectAndUpdate()
            } ))
        }
        
        options.append(GASOptionViewData(text: "Close", closure: {
            self.clearInventoryView()
            self.clearInventoryOptions()
            //self.game.newPlayerMove(
            GASEvent.next()
            //self.drawInterfacePlayerOptions(options: self.game.options)
        } ))
        
        displayOptions(options)
    }
    
    func generateInventory(container: GASContainer) {
        clearInventoryView()
        self.inventoryView = GASInventoryView(parent: self.parent,
                                              source: container, rows: 5, columns: 5,
                                              size: inventoryViewSize, scale: inventoryViewScale,
                                              onItemTouch: {
                                                item in
                                                self.inventoryView!.selected = item
                                                self.generateInventoryOptions()
                                                
        })
        self.inventoryView!.position = CGPoint(x: inventoryViewMargin, y: inventoryViewMargin)
        self.inventoryView!.draw()
        self.generateInventoryOptions()
        
    }
    
    func generateInventoryOptions() {
        var options : [GASOptionViewData] = []
        if let player = game.player {
            if let item = inventoryView?.selected {
                options.append(GASOptionViewData(text: "Take", closure: {
                    player.inventory.append(item)
                    if let index = self.inventoryView!.source.inventory.index(where:  { $0.id == item.id } ) {
                        self.inventoryView!.source.inventory.remove(at: index)
                    }
                    self.inventoryView!.selected = nil
                    self.inventoryView!.update()
                    self.generateInventoryOptions()
                }))
            }
            if inventoryView!.source.inventory.count > 0 {
                options.append(GASOptionViewData(text: "Take all", closure: {
                    for i in self.inventoryView!.source.inventory {
                        player.inventory.append(i)
                    }
                    self.inventoryView!.source.inventory = []
                    self.clearInventoryView()
                    self.clearInventoryOptions()
                    //self.game.newPlayerMove(
                    GASEvent.next()
                }))
            }
        }
        
        options.append(GASOptionViewData(text: "Close", closure: {
            self.clearInventoryView()
            self.clearInventoryOptions()
            //self.game.newPlayerMove()
            GASEvent.next()
        } ))
        
        displayOptions(options)
    }
    
}
