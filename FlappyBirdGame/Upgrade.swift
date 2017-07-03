//
//  Upgrade.swift
//  FlappyBirdGame
//
//  Created by Pragun Sharma on 02/07/17.
//  Copyright © 2017 Pragun Sharma. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

struct powerUpClicked {
    static var isPowerupClicked = Bool()
    
}

class Cost {
    
    var costOfPowerUps = SKLabelNode()
    var price = Int()

}

class Upgrade: SKScene {
    
    let numberofCoinsLabel = SKLabelNode()
    var numberOfCoins = SKSpriteNode()
    var shieldPwrUp = SKSpriteNode()
    var costOfPowerUps = SKLabelNode()
    let costForShield = Cost()
    
    override func didMove(to view: SKView) {

        createScene()

    }
    
    func createScene() {
        
        let background = SKSpriteNode(imageNamed: "Background")
        background.anchorPoint = CGPoint.zero
        background.position = CGPoint(x: 0, y: 0)
        background.name = "background"
        background.size = (self.view?.bounds.size)!
        background.alpha = 0.5
        self.addChild(background)
        
        shieldPwrUp = SKSpriteNode(imageNamed: "shieldPowerUp")
        shieldPwrUp.size = CGSize(width: 256, height: 256)
        shieldPwrUp.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2 + 100)
        shieldPwrUp.setScale(0.5)
        shieldPwrUp.zPosition = 1
        self.addChild(shieldPwrUp)

        costForShield.price = 30
        costForShield.costOfPowerUps.fontName = "04b_19"
        costForShield.costOfPowerUps.text = ("\(costForShield.price)")
        costForShield.costOfPowerUps.position = CGPoint(x: self.frame.width/2 , y: self.frame.height/2)
        costForShield.costOfPowerUps.zPosition = 1
        self.addChild(costForShield.costOfPowerUps)
        
        //Add an image of coin when the game is not started
        numberOfCoins = SKSpriteNode(imageNamed: "CoinIcon")
        numberOfCoins.position = CGPoint(x: self.frame.width/2 , y: self.frame.height/2 - 150)
        numberOfCoins.size = CGSize(width: 50, height: 50)
        numberOfCoins.physicsBody = SKPhysicsBody(rectangleOf: numberOfCoins.size)
        numberOfCoins.physicsBody?.affectedByGravity = false
        numberOfCoins.physicsBody?.isDynamic = false
        numberOfCoins.physicsBody?.categoryBitMask = PhysicsStruct.Score
        numberOfCoins.physicsBody?.collisionBitMask = 0
        numberOfCoins.physicsBody?.contactTestBitMask = 0
        numberOfCoins.zPosition = 1
        numberOfCoins.setScale(0.8)
        self.addChild(numberOfCoins)
        
        numberofCoinsLabel.text = "\(PlayerScore.numberOfCoinsCollected)"
        numberofCoinsLabel.fontName = "04b_19"
        numberofCoinsLabel.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2 - 200)
        numberofCoinsLabel.zPosition = 1
        self.addChild(numberofCoinsLabel)
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //Check if User clicked on the powerup
        for touch in touches {
            let location = touch.location(in: self)
            if(shieldPwrUp.contains(location)) {
                if(PlayerScore.numberOfCoinsCollected - costForShield.price >= 0) {
                    powerUpClicked.isPowerupClicked = true
                    updateCoinsLeft()
                }
                
            }
        }
    }
    
    func updateCoinsLeft() {
        
         PlayerScore.numberOfCoinsCollected -= costForShield.price
         numberofCoinsLabel.text = "\(PlayerScore.numberOfCoinsCollected)"
    }
}
