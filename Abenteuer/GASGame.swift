//
//  GASGame.swift
//  Abenteuer
//
//  Created by Christian Blomqvist on 2017-03-08.
//  Copyright © 2017 Christian Blomqvist. All rights reserved.
//

import Foundation

enum GameOption : Int {
    case attack = 0
    case search = 1
    case inventory = 2
    case goNorth = 3
    case goEast = 4
    case goSouth = 5
    case goWest = 6
}

func stringForOption(_ option: GameOption) -> String {
    switch(option) {
    case .attack:       return "Attack"
    case .search:       return "Search"
    case .inventory:    return "Check Inventory"
    case .goNorth:      return "Go north"
    case .goEast:       return "Go east"
    case .goSouth:      return "Go south"
    case .goWest:       return "Go west"
    }
}
    
class GASGame {

    var scene : GASScene?
    var options : [(String,String)]?
    //var player : GASPlayer!
    
    init() {
        newScene()
        generateOptions()
    }
    
    func newScene() {
        let rndScene = [GASScene.keyScene01, GASScene.keyScene02, GASScene.keyScene03, GASScene.keyScene04]
        let rndIndex = Int(arc4random_uniform(UInt32(rndScene.count)))
        NSLog("GASGame.newScene: index = \(rndIndex)   scene = \(rndScene[rndIndex])")
        scene = GASScene(id: rndScene[rndIndex])
    }
    
    func generateOptions() {
        options = []
        var optionsCount = 1
        if let scene = self.scene {
            if scene.monsters.count > 0 {
                switch(scene.monsters.count) {
                case 1: options!.append(("\(stringForOption(.attack)) \(scene.monsters.first!)","option\(optionsCount)"))
                default: options!.append(("\(stringForOption(.attack)) Monsters","option\(optionsCount)"))
                }
                optionsCount += 1
            }
            if scene.containers.count > 0 {
                options!.append(("\(stringForOption(.search)) \(scene.containers.first!)","option\(optionsCount)"))
                optionsCount += 1
            }
            if scene.paths.count > 0 {
                options!.append(("\(stringForOption(scene.paths.first!))","option\(optionsCount)"))
                optionsCount += 1
            }
        }
        
    }

}
