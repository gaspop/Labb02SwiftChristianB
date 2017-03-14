//
//  GASNodeProtocol.swift
//  Abenteuer
//
//  Created by Christian Blomqvist on 2017-03-11.
//  Copyright © 2017 Christian Blomqvist. All rights reserved.
//

import Foundation
import SpriteKit

enum GASNodePivot {
    case topLeft, center, bottomCenter
}

protocol GASNodeProtocol {
    
    var width : CGFloat { get set }
    var height : CGFloat { get set }

    var x : CGFloat { get set }
    var y : CGFloat { get set }
    
    func position(_ x: CGFloat, _ y: CGFloat) -> Void
    func size(_ width: CGFloat, _ height: CGFloat) -> Void
    
    var pivotMode : GASNodePivot { get set }
    
    var onTouchClosure : ((Void) -> Void)? { get set }
    
}
