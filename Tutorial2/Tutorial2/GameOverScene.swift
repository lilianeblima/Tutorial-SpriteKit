//
//  GameOverScene.swift
//  Tutorial2
//
//  Created by Liliane Bezerra Lima on 05/05/15.
//  Copyright (c) 2015 Liliane Bezerra Lima. All rights reserved.
//

import UIKit
import SpriteKit

let GameOverLabelCategoryName = "gameOverLabel"

class GameOverScene: SKScene {
    var gameWon : Bool = false {
        didSet {
                 let gameOverLabel = childNodeWithName(GameOverLabelCategoryName) as! SKLabelNode
                 gameOverLabel.text = gameWon ? "Game Won" : "Game Over"
               }
    }
    
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
    if let view = view {
        let gameScene = GameScene.unarchiveFromFile("GameScene") as! GameScene
        view.presentScene(gameScene)
                        }
    }
    
    
}

