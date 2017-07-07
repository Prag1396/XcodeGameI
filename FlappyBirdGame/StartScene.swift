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
    
    var startLabel = SKLabelNode()
    
    let texture = [SKTexture(imageNamed: "Background"), SKTexture(imageNamed: "Ground"), SKTexture(imageNamed: "Ghost"), SKTexture(imageNamed: "shieldPowerUp"), SKTexture(imageNamed: "magnetIcon"), SKTexture(imageNamed: "RestartBtn"), SKTexture(imageNamed: "CoinIcon"), SKTexture(imageNamed: "PowerUpButton"), SKTexture(imageNamed: "Coin"), SKTexture(imageNamed: "Wall")]
    
    override func didMove(to view: SKView) {
     
        SKTexture.preload(texture, withCompletionHandler: {})
        
        let background = SKSpriteNode(imageNamed: "Background")
        background.anchorPoint = CGPoint.zero
        background.position = CGPoint(x: 0, y: 0)
        background.name = "Background"
        background.size = (self.view?.bounds.size)!
        self.addChild(background)
        
        startLabel.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2 + 100)
        startLabel.zPosition = 2
        startLabel.text = "TAP TO START!"
        startLabel.fontSize = 50
        self.addChild(startLabel)

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
 
        hasGameStarted.gameStarted = true
        //Load Game Scene
        let gameScene = GameScene(fileNamed: "GameScene")
        self.scene?.view?.presentScene(gameScene!, transition: SKTransition.doorsCloseHorizontal(withDuration: 0.8))

    }
    
}
