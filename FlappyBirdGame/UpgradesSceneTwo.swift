//
//  UpgradesSceneTwo.swift
//  FlappyBirdGame
//
//  Created by Pragun Sharma on 03/07/17.
//  Copyright © 2017 Pragun Sharma. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class UpgradeSceneTwo: SKScene {
    
    let numberofCoinsLabel = SKLabelNode()
    var numberOfCoins = SKSpriteNode()
    var magnetPowerUp = SKSpriteNode()
    var costForMagnet = Cost()
    var homeButton = SKSpriteNode()

    override func didMove(to view: SKView) {
        
        let swipedRight = UISwipeGestureRecognizer(target: self, action: #selector(userSwipedRight))
        swipedRight.direction = UISwipeGestureRecognizerDirection.right
        self.view?.addGestureRecognizer(swipedRight)
        createScene()
        
        
    }
    
    func userSwipedRight() {
    
        //Load the second upgrade scene
        let upgradeSceneload = GameScene(fileNamed: "UpgradesScene")
        self.scene?.view?.presentScene(upgradeSceneload!, transition: SKTransition.crossFade(withDuration: 0.5))
    }
    
    func createScene() {
        
        let background = SKSpriteNode(imageNamed: "Background")
        background.anchorPoint = CGPoint.zero
        background.position = CGPoint(x: 0, y: 0)
        background.name = "background"
        background.size = (self.view?.bounds.size)!
        background.alpha = 0.5
        self.addChild(background)
        
        magnetPowerUp = SKSpriteNode(imageNamed: "magnetIcon")
        magnetPowerUp.size = CGSize(width: 256, height: 256)
        magnetPowerUp.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2 + 100)
        magnetPowerUp.setScale(0.5)
        magnetPowerUp.zPosition = 1
        self.addChild(magnetPowerUp)
        
        
        costForMagnet.price = 4
        costForMagnet.costOfPowerUps.fontName = "04b_19"
        costForMagnet.costOfPowerUps.text = ("\(costForMagnet.price)")
        costForMagnet.costOfPowerUps.position = CGPoint(x: self.frame.width/2 , y: self.frame.height/2)
        costForMagnet.costOfPowerUps.zPosition = 1
        self.addChild(costForMagnet.costOfPowerUps)
        
        
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
        
        
        homeButton = SKSpriteNode(imageNamed: "homeButton")
        homeButton.size = CGSize(width: 256, height: 256)
        homeButton.position = CGPoint(x: self.frame.width/2 - 150, y: self.frame.height/2 + 300)
        homeButton.zPosition = 2
        homeButton.setScale(0.17)
        self.addChild(homeButton)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //Check if User clicked on the powerup
        for touch in touches {
            let location = touch.location(in: self)
            if(magnetPowerUp.contains(location)) {
                if(PlayerScore.numberOfCoinsCollected - costForMagnet.price >= 0) {
                    powerUpClicked.magnetCount += 1
                    
                    let magPowerUpsSaved  = UserDefaults.standard
                    magPowerUpsSaved.set(powerUpClicked.magnetCount, forKey: "NumberOfMagnetsCountBought")
                    magPowerUpsSaved.synchronize()
                    
                    updateCoinsLeft()
                }
                
            }
            
            //If homeButton is Pressed
            if(homeButton.contains(location)) {
                //load gamescene
                let gameScene = GameScene(fileNamed: "GameScene")
                self.scene?.view?.presentScene(gameScene!, transition: SKTransition.crossFade(withDuration: 0.5))
            }
        }
    }
    
    func updateCoinsLeft() {
        
        PlayerScore.numberOfCoinsCollected -= costForMagnet.price
        numberofCoinsLabel.text = "\(PlayerScore.numberOfCoinsCollected)"
        
        let getCoinsCollected = UserDefaults.standard
        getCoinsCollected.set(PlayerScore.numberOfCoinsCollected, forKey: "numberOfCoinsCollected")
        getCoinsCollected.synchronize()
    }
    
    
}
