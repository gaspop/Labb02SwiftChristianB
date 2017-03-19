//
//  GASInventoryView.swift
//  Abenteuer
//
//  Created by Christian Blomqvist on 2017-03-15.
//  Copyright © 2017 Christian Blomqvist. All rights reserved.
//

import Foundation
import SpriteKit

class GASItemView {
    
    static let maxItemSize : CGFloat = 512
    
    let size : CGSize
    let scale : CGFloat

    let parent : GASInventoryView
    
    var item : GASItem
    var image : GASSprite
    
    var position : CGPoint {
        get {
            return image.position
        }
        set(value) {
            image.position = value
        }
    }
    
    init(parent: GASInventoryView, item: GASItem, image: GASSprite, size: CGSize, scale: CGFloat) {
        self.parent = parent
        self.item = item
        self.image = image
        self.size = size
        self.scale = scale
        
        self.image.onTouchClosure = { self.parent.onItemTouchClosure(self.item) }
        self.image.isUserInteractionEnabled = true
    }
    
}

class GASInventoryView {
    
    static let zPosition : CGFloat = 2.0
    
    let size : CGSize
    let scale : CGFloat
    let rows : Int
    let columns : Int
    let itemSize : CGFloat
    
    let parent : GameScene
    var source : GASInventory
    var inventory : [GASItem] {
        return source.inventory
    }
    var selected : GASItem?
    
    private let view : GASRectangle
    var itemSlots : [GASSprite]
    var itemViews : [GASItemView]
    
    var onItemTouchClosure : (GASItem) -> Void
    
    var position : CGPoint {
        get {
            return view.position
        }
        set(value) {
            view.position = value
        }
    }
    
    func draw() {
        for row in 0 ..< rows {
            for col in 0 ..< columns {
                let slot = GASSprite(imageNamed: "inventorySlot",
                                     size: CGSize(width: itemSize, height: itemSize),
                                     parent: self.view, onTouch: nil)
                slot.anchorPoint = GASPivot.center
                slot.position = CGPoint(x: (itemSize / 2) + itemSize * CGFloat(col),
                                        y: (itemSize / 2) + itemSize * CGFloat(row))
                slot.zRotation = CGFloat(90 * random(4)) * 3.14 / 180
                slot.zPosition = self.parent.zPosition + 0.1
                itemSlots.append(slot)
            }
        }
        update()
    }
    
    func update() {
        clear()
        var itemIndex : Int = 0
        for row in 0 ..< rows {
            for col in 0 ..< columns {
                if itemIndex < inventory.count {
                    let item : GASItem = inventory[itemIndex]
                    let itemView = GASItemView(parent: self, item: inventory[itemIndex],
                                               image: GASSprite(imageNamed: itemImageForTypeId(id: item.typeId),
                                                                size: CGSize(width: itemSize, height: itemSize),
                                                                parent: self.view, onTouch: nil),
                                               size: CGSize(width: itemSize, height: itemSize), scale: self.scale)
                    itemView.image.setPosition(itemSize * CGFloat(col), itemSize * CGFloat(row))
                    itemView.image.zPosition = self.parent.zPosition + 0.2
                    itemViews.append(itemView)
                    itemIndex += 1
                }
            }
        }
    }
    
    func clear() {
        for v in itemViews {
            v.image.removeFromParent()
        }
        itemViews = []
    }
    
    func close() {
        clear()
        for s in itemSlots {
            s.removeFromParent()
        }
        view.removeFromParent()
    }
    
    init(parent: GameScene, source: GASInventory, rows: Int, columns: Int,
         size: CGFloat, scale: CGFloat, onItemTouch: @escaping (GASItem) -> Void) {
        self.parent = parent
        self.source = source
        self.itemSlots = []
        self.itemViews = []
        self.rows = rows
        self.columns = columns
        self.scale = scale
        
        self.onItemTouchClosure = onItemTouch
        
        self.itemSize = size / CGFloat(self.columns)
        self.size = CGSize(width: size, height: itemSize * CGFloat(rows))
        
        self.view = GASRectangle(rectOf: self.size, radius: 0, color: UIColor.lightGray,
                                 parent: self.parent, onTouch: nil)
        self.view.zPosition = GASInventoryView.zPosition
        
    }
    
    func itemImageForTypeId(id: GASItemTypeId) -> String {
        switch(id) {
        case .wpnBat:               return "itemWpnClub"
        case .wpnSword:             return "itemWpnSword"
        case .wpnAxe:               return "itemWpnAxe"
        case .armShieldWooden:      return "itemArmShieldWooden"
        case .armShieldSteel:       return "itemArmShieldSteel"
        case .conFoodBread:         return "itemConFoodBread"
        case .conPotion:            return "itemConPotion"
        case .treGoldCoin:          return "itemTreMoney"
        case .treJewel:             return "itemTreGem"
        case .treNecklace:          return "itemTreMedal"
            
        default:    return "inventorySlot"
        }
    }
    
}
