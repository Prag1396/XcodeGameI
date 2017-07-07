//
//  StartScene.swift
//  FlappyBirdGame
//
//  Created by Pragun Sharma on 07/07/17.
//  Copyright © 2017 Pragun Sharma. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class StartScene: SKScene {
    
    var ground = SKSpriteNode()
    var ghost = SKSpriteNode()
    var upgradeButton = SKSpriteNode()
    var startLabel = SKLabelNode()
    
    override func didMove(to view: SKView) {
     
        let background = SKSpriteNode(imageNamed: "Background")
        background.anchorPoint = CGPoint.zero
        background.position = CGPoint(x: 0, y: 0)
        background.name = "background"
        background.size = (self.view?.bounds.size)!
        self.addChild(background)
        
        ground = SKSpriteNode(imageNamed: "Ground")
        ground.setScale(0.5)
        ground.position = CGPoint(x: self.frame.width / 2, y: 0 + ground.frame.height / 2)
        ground.zPosition = 3
        self.addChild(ground)
        
        ghost = SKSpriteNode(imageNamed: "Ghost")
        ghost.size = CGSize(width: 60, height: 70)
        ghost.position = CGPoint(x: self.frame.width / 2 - ghost.frame.width, y: self.frame.height / 2)
        ghost.zPosition = 2
        self.addChild(ghost)
        
        startLabel.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2 + 100)
        startLabel.zPosition = 2
        startLabel.text = "TAP TO START!"
        startLabel.fontName = "04b_19"
        startLabel.fontSize = 50
        self.addChild(startLabel)
        
        

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        hasGameStarted.gameStarted = true
        //Load Game Scene
        let gameScene = GameScene(fileNamed: "GameScene")
        self.scene?.view?.presentScene(gameScene!)
        

    }
    
}
