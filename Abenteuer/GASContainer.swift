//
//  GASContainer.swift
//  Abenteuer
//
//  Created by Christian Blomqvist on 2017-03-12.
//  Copyright © 2017 Christian Blomqvist. All rights reserved.
//

import Foundation

class GASContainer : GASSceneObject, GASInventory {
    
    static var sceneObjectType : GASObjectType {
        get { return .container }
    }
    
    var scene : GASScene
    var type : GASContainerType
    
    var geometry : GASSceneObjectGeometry
    
    var inventory : [GASItem] = []
    
    init(type: GASContainerType, scene: GASScene, x: Float, y: Float, width : Float, height : Float) {
        self.type = type
        self.scene = scene
        self.geometry = GASSceneObjectGeometry(x: x, y: y, width: width, height: height)
    }
    
    init(type: GASContainerType, scene: GASScene) {
        self.type = type
        self.scene = scene
        self.geometry = GASSceneObjectGeometry(x: 0, y: 0, width: 0, height: 0)
    }
    
    func position(_ x: Float, _ y: Float) {
        geometry.x = x
        geometry.y = y
    }
    func size(_ width: Float, _ height: Float) {
        geometry.width = width
        geometry.height = height
    }
    
}

enum GASContainerType : Int {
    
    case undefined = 0
    case chest = 1
    case wreckage = 2
    case hollowTree = 3
    
}

func stringForContainer(_ container: GASContainerType) -> String {
    switch(container) {
    case .chest:        return "treasure chest"
    case .hollowTree:   return "tree"
    case .wreckage:     return "wreckage"
    default:    return "nothing"
    }
    
}


