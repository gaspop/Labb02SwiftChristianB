//
//  GASScenery.swift
//  Abenteuer
//
//  Created by Christian Blomqvist on 2017-03-12.
//  Copyright © 2017 Christian Blomqvist. All rights reserved.
//

import Foundation

class GASScenery : GASSceneObject {
    
    static var sceneObjectType : GASObjectType {
        get { return .scenery }
    }
    
    var scene : GASScene
    var type : GASSceneryType
    
    var geometry : GASSceneObjectGeometry
    
    init(type: GASSceneryType, scene: GASScene, x: Float, y: Float, width : Float, height : Float) {
        self.type = type
        self.scene = scene
        self.geometry = GASSceneObjectGeometry(x: x, y: y, width: width, height: height)
    }
    
    init(type: GASSceneryType, scene: GASScene) {
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

enum GASSceneryType : Int {
    
    case tree = 1
    case rock = 2
    
}


