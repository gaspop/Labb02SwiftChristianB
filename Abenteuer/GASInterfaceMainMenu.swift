//
//  GASInterfaceMenu.swift
//  Abenteuer
//
//  Created by Christian Blomqvist on 2017-03-19.
//  Copyright © 2017 Christian Blomqvist. All rights reserved.
//

import Foundation
import SpriteKit

class GASInterfaceMainMenu {
    
    let parent : GameScene
    private var optionView : GASOptionView?
    
    init(parent: GameScene) {
        self.parent = parent
    }
    
    func displayOptions() {
        if let optionView = self.optionView {
            optionView.close()
        }
        let font = UIFont(name: "Helvetica", size: 64 * parent.viewScale)
        let options : [GASOptionViewData] = [
            GASOptionViewData(text: "Start New Game", closure: {
                self.optionView!.close()
                self.parent.setupNewGame()
            } ) ]
        optionView = GASOptionView(parent: parent,
                                   zPosition: 1.0,
                                   optionWidth: parent.size.width * 0.75, optionHeight: 128 * parent.viewScale, optionSpacing: 64 * parent.viewScale,
                                   optionFont: font, options: options)
        optionView!.position = CGPoint(x: (parent.size.width - optionView!.size.width) / 2 ,
                                      y: (parent.size.height / 2) - (optionView!.size.height / 2))
    }
    
}
