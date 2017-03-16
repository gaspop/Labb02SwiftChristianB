//
//  GameScene.swift
//  Abenteuer
//
//  Created by Christian Blomqvist on 2017-03-08.
//  Copyright © 2017 Christian Blomqvist. All rights reserved.
//

import SpriteKit
import GameplayKit

enum GameInterfaceAction {
    case normal
    case selectNewTarget
}

class GameScene: SKScene {
    
    public let viewScreenShare : CGFloat = 0.45
    public let maxViewSize : CGFloat = 1024
    public var viewSize : CGFloat!
    public var viewScale : CGFloat!
    public var viewGap : CGFloat!
    
    public let buttonHeight : CGFloat = 128
    public let buttonGap : CGFloat = 64
    
    var gameView : GASGameView!
    var inventoryView : GASInventoryView?
    var buttons : [GASButton] = []
    
    var game : GASGame!
    var sceneFrame : SKShapeNode!
    
    //var sceneView : SKSpriteNode!
    
    override func didMove(to view: SKView) {
        
        anchorPoint = GASNodePivot.topLeft
        
        game = GASGame()
        game.player = GASPlayer(game: game,
                                name: "Ture",
                                stats: GASUnitStats(health: 200, strength: 1, speed: 3, damage: 1),
                                geometry: GASSceneObjectGeometry())
        game.player!.inventory = [GASWeapon.create(game: game, id: .wpnSword),
                                  GASArmor.create(game: game, id: .armShieldWooden),
                                  GASWeapon.create(game: game, id: .wpnSword)]
        game.player!.weapon = GASWeapon.create(game: game, id: .wpnPistol)
        game.player!.armor = GASArmor.create(game: game, id: .armShieldSteel)
        game.newScene()
        game.newBattle()
        game.evaluateBattle()
        game.generateOptions()
        
        viewSize = size.height * viewScreenShare
        viewScale = viewSize / maxViewSize
        viewGap = (size.width - viewSize) / 2
        
        drawInterfaceGame()
        drawInterfacePlayerOptions(options: game.options)
        
        /*
        let test = GASSprite(imageNamed: "Spaceship")
        addChild(test)
        test.position(0,0)
        */
        //let test = GASRectangle(rectOf: CGSize(width: 256, height: 256), radius: 16, color: UIColor.green, name: nil, parent: self)
        //addChild(test)
        //test.pivotMode = .topLeft
        //test.position(0,0)
        //test.zPosition = 1
        //test.x = 0
        //test.y = 0
        //drawTest()
    }
    
    func drawInventory(container: GASContainer) {
        clearInterfaceButtons()
        if let inventoryView = self.inventoryView {
            inventoryView.close()
            self.inventoryView = nil
        }
        
        self.inventoryView = GASInventoryView(parent: self, source: container,
                                              rows: 5, columns: 5, size: viewSize, scale: viewScale,
                                              overlay: nil, onItemTouch: {
                                                item in
                                                self.inventoryView!.selected = item
                                                self.drawInventoryOptions()
        })
        self.inventoryView!.position = CGPoint(x: viewGap,y: viewGap)
        self.inventoryView!.draw()
        self.drawInventoryOptions()
        
    }
    
    func drawInventoryOptions() {
        clearInterfaceButtons()
        var textAndClosure : [(String,() -> Void)] = []
        if let player = game.player {
            if let item = inventoryView?.selected {
                textAndClosure.append(("Take", {
                    player.inventory.append(item)
                    if let index = self.inventoryView!.source.inventory.index(where:  { $0.id == item.id } ) {
                        self.inventoryView!.source.inventory.remove(at: index)
                    }
                    self.inventoryView!.selected = nil
                    self.inventoryView!.update()
                    self.drawInventoryOptions()
                }))
            }
            if inventoryView!.source.inventory.count > 0 {
                textAndClosure.append(("Take all", {
                    for i in self.inventoryView!.source.inventory {
                        player.inventory.append(i)
                    }
                    self.inventoryView!.source.inventory = []
                    self.inventoryView!.close()
                    self.inventoryView = nil
                    self.game.generateOptions()
                    self.drawInterfacePlayerOptions(options: self.game.options)
                }))
            }
        }
        
        
        
        textAndClosure.append(("Close", {
            self.inventoryView!.close()
            self.inventoryView = nil
            self.game.generateOptions()
            self.drawInterfacePlayerOptions(options: self.game.options)
        } ))
        
        let buttonGap = (self.buttonHeight * viewScale) + (self.buttonGap * viewScale)
        let buttonStartY = (viewGap * 2) + inventoryView!.size.height
        
        for (index, tuple) in textAndClosure.enumerated() {
            drawInterfaceButton(parent: self,
                                position: CGPoint(x: viewGap, y: buttonStartY + (buttonGap * CGFloat(index))),
                                text: tuple.0, onTouch: tuple.1 )
        }
    }

    func drawPlayerInventory() {
        clearInterfaceButtons()
        if let inventoryView = self.inventoryView {
            inventoryView.close()
            self.inventoryView = nil
        }
        
        if let player = game.player {
            self.inventoryView = GASInventoryView(parent: self,
                                                  source: player,
                                                  rows: 5, columns: 5, size: viewSize, scale: viewScale,
                                                  overlay: nil,
                                                  onItemTouch: {
                                                    item in
                                                    self.inventoryView!.selected = item
                                                    self.drawPlayerInventoryOptions()
                                                    
                                                  })
            self.inventoryView!.position = CGPoint(x: viewGap,y: viewGap)
            self.inventoryView!.draw()
            self.drawPlayerInventoryOptions()
        }
    }
    
    func drawPlayerInventoryOptions() {
        clearInterfaceButtons()
        var textAndClosure : [(String,() -> Void)] = []
        if let player = game.player,
           let item = inventoryView?.selected {
            var isSelectedWeaponId = false
            var isSelectedArmorId = false
            
            if let item = item as? GASWeapon {
                if let current = player.weapon,
                    current.id == item.id {
                    isSelectedWeaponId = true
                    textAndClosure.append(("Remove", {
                        player.weapon = nil
                        self.deselectAndUpdate()
                    }))

                } else {
                    textAndClosure.append(("Equip", {
                        player.weapon = item
                        self.deselectAndUpdate()
                    }))
                }
            } else if let item = item as? GASArmor {
                if let current = player.armor,
                    current.id == item.id {
                        isSelectedArmorId = true
                        textAndClosure.append(("Remove", {
                            player.armor = nil
                            self.deselectAndUpdate()
                        }))
                } else {
                    textAndClosure.append(("Equip", {
                        player.armor = item
                        self.deselectAndUpdate()
                    }))
                }
            }
            textAndClosure.append(("Drop item", {
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
                self.deselectAndUpdate()
            } ))
        }
        
        textAndClosure.append(("Close", {
            self.inventoryView!.close()
            self.inventoryView = nil
            self.game.generateOptions()
            self.drawInterfacePlayerOptions(options: self.game.options)
        } ))
        
        let buttonGap = (self.buttonHeight * viewScale) + (self.buttonGap * viewScale)
        let buttonStartY = (viewGap * 2) + inventoryView!.size.height
        
        for (index, tuple) in textAndClosure.enumerated() {
            drawInterfaceButton(parent: self,
                                position: CGPoint(x: viewGap, y: buttonStartY + (buttonGap * CGFloat(index))),
                                text: tuple.0, onTouch: tuple.1 )
        }
    }
    
    func deselectAndUpdate() {
        self.inventoryView!.selected = nil
        self.drawPlayerInventoryOptions()
    }
    
    func drawInterfaceGame() {
        gameView = GASGameView(parent: self,
                               size: CGSize(width: viewSize, height: viewSize),
                               scale: viewScale)
        gameView.drawScene()
        
        //let sceneYPos = (self.size.height / 2) - (viewSize / 2) - viewGap
        gameView.position = CGPoint(x: viewGap, y: viewGap)
        //gameView.view.anchorPoint = GASNodePivot.center
        /*
        let rectum = GASRectangle(rectOf: CGSize(width: 256, height: 96), radius: 8, color: UIColor.green, parent: nil, onTouch: nil)
        let butt = GASButton(parent: self,
                            shape: rectum, sprite: nil, text: "Arse-Biscuit", textColor: nil, font: UIFont(name: "Helvetica", size: 64 * viewScale), onTouch: { print("Arse")} )
        butt.position = CGPoint(x: viewGap, y: viewGap * 2 + viewSize)
        */
        drawInterfacePlayerOptions(options: game.options)
    }
    
    func clearInterfaceButtons() {
        for b in buttons {
            b.clear()
        }
        buttons = []
    }
    
    func drawInterfaceButton(parent: SKNode, position: CGPoint, text: String, onTouch: (() -> Void)?) {
        
        let buttonSize = CGSize(width: viewSize, height: buttonHeight * viewScale)
        let buttonFont = UIFont(name: "Helvetica", size: 64 * viewScale)
        
        let buttonShape = GASRectangle(rectOf: buttonSize, radius: 4.0, color: UIColor.brown,
                                       parent: nil, onTouch: nil)
        let button = GASButton(parent: parent, shape: buttonShape, sprite: nil,
                               text: text, textColor: nil, font: buttonFont,
                               onTouch: onTouch)
        button.position = CGPoint(x: position.x, y: position.y)
        //button.setPosition(position.x, position.y)
        buttons.append(button)
    }
    
    func drawInterfacePlayerOptions(options: [GASGameOption]?) {
        clearInterfaceButtons()
        
        let buttonGap = (self.buttonHeight * viewScale) + (self.buttonGap * viewScale)
        let buttonStartY = (viewGap * 2) + viewSize
        
        if let options = options {
            for (index,o) in options.enumerated() {
                drawInterfaceButton(parent: self,
                                    position: CGPoint(x: viewGap, y: buttonStartY + (buttonGap * CGFloat(index))),
                                    text: o.text, onTouch: actionForOption(o.type))
            }
        }
        
    }
    
    func actionForOption(_ type: GASGameOptionType) -> (() -> Void)? {
        switch(type) {
        case .attack:       return {
            self.game.continueBattle()
            self.gameView.drawMonsters()
            self.drawInterfacePlayerOptions(options: self.game.options)
            }
        case .continue:     return {
            self.game.continueBattle()
            self.gameView.drawMonsters()
            self.drawInterfacePlayerOptions(options: self.game.options)
            }
        case .travel:       return {
            self.game.newScene()
            self.game.newBattle()
            self.game.evaluateBattle()
            self.game.generateOptions()
            self.gameView.drawScene()
            self.drawInterfacePlayerOptions(options: self.game.options!)
            }
        case .inventory:    return {
            self.drawPlayerInventory()
            }
        case .gather:       return {
            self.drawInventory(container: self.game.scene!.loot)
            }
        case .search:       return {
            self.drawInventory(container: self.game.scene!.containers.first!)
            }
        //default:
        //    return nil
        }
    }
    
    /*func drawTest() {
        let buttonSide = 256 * viewScale
        let buttonSize = CGSize(width: buttonSide, height: buttonSide)
        let buttonImage = GASSprite(imageNamed: "Spaceship", size: nil, name: nil, parent: nil)
        
            //let buttonShape = SKShapeNode(rectOf: buttonSize, cornerRadius: 4.0)
            //buttonShape.fillColor = UIColor.orange
            //buttonShape.strokeColor = UIColor.orange
        let buttonShape = GASRectangle(rectOf: buttonSize, radius: 4.0, color: UIColor.orange, name: "test", parent: nil)
            let buttonFont = UIFont(name: "Helvetica", size: 64 * viewScale)
            let button = GASButton(parent: self,
                                   identifier: "test",
                                   size: buttonSize,
                                   shape: buttonShape,
                                   sprite: buttonImage,
                                   text: nil,
                                   textColor: nil,
                                   font: buttonFont)
            button.position((size.width / 2) - (buttonSide / 2), size.height - buttonSide - viewGap)
            
    }*/
    
    func touchDown(atPoint pos : CGPoint) {
        /*if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }*/
 
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        /*if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }*/
    }
    
    func touchUp(atPoint pos : CGPoint) {
        /*if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }*/
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /*if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }*/
        
        for t in touches {
            self.touchDown(atPoint: t.location(in: self))
            
        }
        
        
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
