//
//  SceneObject.swift
//  Abenteuer
//
//  Created by Christian Blomqvist on 2017-03-11.
//  Copyright © 2017 Christian Blomqvist. All rights reserved.
//

import Foundation

enum GASObjectType : Int {
    case scenery = 0
    case container = 1
    case monster = 2
    case player = 3
    //case item = 4

}

class GASSceneObjectGeometry {
    var x : Float
    var y : Float
    var width : Float
    var height : Float
    
    init(x: Float, y: Float, width: Float, height: Float) {
        self.x = x
        self.y = y
        self.width = width
        self.height = height
    }
}

protocol GASSceneObject {
    
    static var sceneObjectType : GASObjectType { get }
    
    var scene : GASScene { get set }
    
    var geometry : GASSceneObjectGeometry { get set }
    
    func position(_ x: Float, _ y: Float)
    func size(_ width: Float, _ height: Float)
    
}


protocol GASInventory {
    
    var inventory : [GASItem] { get set }
    
}
