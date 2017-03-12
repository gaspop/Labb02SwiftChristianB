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
    
    var gameView : GASGameView!
    
    var game : GASGame!
    var sceneFrame : SKShapeNode!
    
    //var sceneView : SKSpriteNode!
    
    override func didMove(to view: SKView) {
        
        game = GASGame()
        
        viewSize = size.height * viewScreenShare
        viewScale = viewSize / maxViewSize
        viewGap = (size.width - viewSize) / 2
        
        drawInterfaceGame()
        
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
    
    func drawInterfaceGame() {
        gameView = GASGameView(game: game,
                               parent: self,
                               size: CGSize(width: viewSize, height: viewSize),
                               scale: viewScale)
        gameView.drawScene()
        
        let sceneYPos = (self.size.height / 2) - (viewSize / 2) - viewGap
        gameView.view.position = CGPoint(x: 0, y: sceneYPos)
        
        drawInterfacePlayerOptions(options: game.options!)
    }
    
    var buttons : [GASButton] = []
    
    func drawInterfacePlayerOptions(options: [(String,String)]) {
        if buttons.count > 0 {
            NSLog("drawInterfacePlayerOptions: Removing old buttons.")
            for b in buttons {
                b.shape.removeFromParent()
            }
        }
        buttons = []
        
        //let buttonAreaHeight = size.height - viewSize - (viewGap * 3)
        let buttonHeight = 128 * viewScale
        let buttonSize = CGSize(width: viewSize, height: buttonHeight)
        let buttonGap = buttonHeight + (64 * viewScale)
        let offsetY = (viewGap * 2) + viewSize
        
        for (index, tuple) in options.enumerated() {
            //let buttonShape = SKShapeNode(rectOf: buttonSize, cornerRadius: 4.0)
            //buttonShape.fillColor = UIColor.brown
            //buttonShape.strokeColor = UIColor.brown
            let buttonShape = GASRectangle(rectOf: buttonSize, radius: 4.0, color: UIColor.brown, name: nil, parent: nil)
            let buttonFont = UIFont(name: "Helvetica", size: 64 * viewScale)
            let button = GASButton(parent: self,
                                   identifier: tuple.1,
                                   size: buttonSize,
                                   shape: buttonShape,
                                   sprite: nil,
                                   text: tuple.0,
                                   textColor: nil,
                                   font: buttonFont)
            button.position(viewGap, offsetY + (buttonGap * CGFloat(index)))
            buttons.append(button)
        }
        
    }
    
    func drawTest() {
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
            
    }
    
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
            
            let touch:UITouch = touches.first! as UITouch
            let positionInScene = touch.location(in: self)
            let touchedNode = self.atPoint(positionInScene)
            if let name = touchedNode.name
            {
                if name == "gameViewScene"
                {
                    game.newScene()
                    gameView.drawScene()
                    game.generateOptions()
                    drawInterfacePlayerOptions(options: game.options!)
                    print("Touched")
                } else {
                    for b in buttons {
                        if name == b.id! {
                            print(b.text!)
                        }
                    }
                }
            }
            
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
