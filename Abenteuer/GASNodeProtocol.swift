//
//  GASNodeProtocol.swift
//  Abenteuer
//
//  Created by Christian Blomqvist on 2017-03-11.
//  Copyright © 2017 Christian Blomqvist. All rights reserved.
//

import Foundation
import SpriteKit

class GASNodePivot {
    static var topLeft : CGPoint        { return CGPoint(x: 0.0, y: 1.0) }
    static var center : CGPoint         { return CGPoint(x: 0.5, y: 0.5) }
    static var bottomCenter : CGPoint   { return CGPoint(x: 0.5, y: 0.0) }
}

/*
protocol GASNodeProtocol {
    
    var width : CGFloat { get set }
    var height : CGFloat { get set }

    var x : CGFloat { get set }
    var y : CGFloat { get set }
    
    func position(_ x: CGFloat, _ y: CGFloat) -> Void
    //func size(_ width: CGFloat, _ height: CGFloat) -> Void
    
    var onTouchClosure : ((Void) -> Void)? { get set }
    
}
*/
