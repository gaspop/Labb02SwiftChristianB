//
//  GameScene.swift
//  Abenteuer
//
//  Created by Christian Blomqvist on 2017-03-08.
//  Copyright © 2017 Christian Blomqvist. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    public let viewScreenShare : CGFloat = 0.45
    public let maxViewSize : CGFloat = 1024
    public var viewSize : CGFloat!
    public var viewScale : CGFloat!
    public var viewGap : CGFloat!
    
    public let buttonHeight : CGFloat = 128
    public let buttonGap : CGFloat = 64
    
    private var lastEventId : Int = 0
    
    var game : GASGame!
    var gameInterface : GASInterfaceGame!
    var inventoryInterface : GASInterfaceInventory!
    var mainMenuInterface : GASInterfaceMainMenu!
    
    override func didMove(to view: SKView) {
        
        anchorPoint = GASPivot.topLeft
        
        viewSize = size.height * viewScreenShare
        viewScale = viewSize / maxViewSize
        viewGap = (size.width - viewSize) / 2
        
        mainMenuInterface = GASInterfaceMainMenu(parent: self)
        mainMenuInterface.displayOptions()
    }

    func setupInterfaceGame() {
        gameInterface = GASInterfaceGame(parent: self)
        gameInterface.gameView.drawScene()
        inventoryInterface = GASInterfaceInventory(parent: self)
    }
    
    func setupNewGame() {
        game = GASGame()
        game.player = GASPlayer(game: game,
                                name: "Ture",
                                stats: GASUnitStats(health: 120, strength: 1, speed: 3, damage: 2),
                                geometry: GASSceneObjectGeometry())
        game.player!.weapon = GASWeapon.create(game: game, id: .wpnBat)
        game.player!.armor = nil
        game.player!.inventory = [game.player!.weapon!, GASConsumable.create(game: game, id: .conFoodBread)]
        
    }
    
    

    func touchDown(atPoint pos : CGPoint) {

    }
    
    func touchMoved(toPoint pos : CGPoint) {

    }
    
    func touchUp(atPoint pos : CGPoint) {

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

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
        if let event = GASEvent.current {
            if event.eventId != lastEventId || !event.hold {
                handleEvent(event)
            }
        } else {
            lastEventId = 0
        }
        
    }
    
    func handleEvent(_ event: GASEvent) {
        if event is GASGameEvent {
            handleGameEvent(event as! GASGameEvent)
        } else if event is GASSceneEvent {
            handleSceneEvent(event as! GASSceneEvent)
        } else if event is GASBattleEvent {
            handleBattleEvent(event as! GASBattleEvent)
        } else {
            NSLog("handleEvent: Missing event handler.")
        }
        lastEventId = event.eventId
        
        if let currentEvent = GASEvent.current {
            if event.eventId == currentEvent.eventId && !event.hold {
                print("handleEvent calling next")
                GASEvent.next()
                if let nextEvent = GASEvent.current {
                    handleEvent(nextEvent)
                }
            }
        }
    }
    
    func handleGameEvent(_ event: GASGameEvent) {
        NSLog("handleGameEvent: \(event.type)   id: \(event.eventId)")
        switch(event.type) {
        case .newGame:
            setupInterfaceGame()
            game.newScene()
            
        case .gameReset:
            gameInterface.close()
            mainMenuInterface.displayOptions()
            
        case .gameEnd:
            gameInterface.displayMessage("You have succumed to your wounds and died. You managed to reach level \(game.player!.level). Game over, dude!")
            
        case .playerLevelUp:
            gameInterface.displayMessage("You have gained a level, you are now at level \(game.player!.level). You will require \(game.player!.experienceLimit) experience to reach the next level.")
        case .showInventory:
            break
        case .showContainer:
            break
        case .showLoot:
            break
            
        default:
            NSLog("handleGameEvent: Missing event handler.")
            break
            
        }
    }
    
    func handleSceneEvent(_ event: GASSceneEvent) {
        NSLog("handleSceneEvent: \(event.type)   id: \(event.eventId)")
        switch(event.type) {
        case .newScene:
            gameInterface.gameView.drawScene()
        
        case .describeScene:
            gameInterface.displayMessage(game.scene!.describeScene())
            
        case .playerMakeMove:
            gameInterface.generatePlayerOptions()
        /*default:
            NSLog("handleSceneEvent: Missing event handler.")
            break
         */
        }
    }
    func handleBattleEvent(_ event: GASBattleEvent) {
        NSLog("handleBattleEvent: \(event.type)   id: \(event.eventId)")
        switch(event.type) {
        case .battleStart:
            gameInterface.displayMessage(("There are monsters here. Prepare for battle!"))
            
        case .battleEnd:
            gameInterface.displayMessage(("You have emerged victorious from the battle!"))
            
        case .newTurnForPlayer:
            gameInterface.generatePlayerOptions()
            
        case .newTurnForMonster:
            game.battle!.takeTurn()
            
        case .playerAttacks:
            break
            
        case .playerHitTarget:
            let monster = game.scene!.monsters.filter( { $0.id == event.targetId } ).first!
            let message = "You hit the \(monster.type) for \(Int(event.value)) points!"
            gameInterface.displayMessage(message)
            break
            
        case .playerMissTarget:
            let monster = game.scene!.monsters.filter( { $0.id == event.targetId } ).first!
            let message = "You screw up royally and swing completely in the wrong direction, missing the \(monster.type)."
            gameInterface.displayMessage(message)
            
        case .playerDies:
            GASEvent.clearAll()
            GASEvent.new(GASGameEvent(.gameEnd, hold: true))
            GASEvent.new(GASGameEvent(.gameReset))
            
        case .playerFinishedTurn:
            gameInterface.generatePauseOptions()
            
        case .monsterAttacks:
            break
            
        case .monsterHitTarget:
            let monster = game.scene!.monsters.filter( { $0.id == event.unitId } ).first!
            let message = "The \(monster.type) hits you for \(Int(event.value)) points!"
            gameInterface.displayMessage(message)
            
        case .monsterMissTarget:
            let monster = game.scene!.monsters.filter( { $0.id == event.unitId } ).first!
            let message = "The \(monster.type) fails miserably and misses you."
            gameInterface.displayMessage(message)
            
        case .monsterDies:
            print("Unit: \(event.unitId)   Target: \(event.targetId)")
            let monster = game.scene!.monsters.filter( { $0.id == event.targetId } ).first!
            let message = "You have defeated the \(monster.type) and gain \(monster.experienceReward) experience points!"
            gameInterface.gameView.drawMonsters()
            gameInterface.displayMessage(message)
        
        case .monsterFinishedTurn:
            GASEvent.finish()
        /*
        default:
            NSLog("handleBattleEvent: Missing event handler.")
            break
        */
        }
 
    }
    
}
