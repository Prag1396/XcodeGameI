//
//  GameScene.swift
//  FlappyBirdGame
//
//  Created by Pragun Sharma on 27/06/17.
//  Copyright © 2017 Pragun Sharma. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

struct PhysicsStruct {
    static let ghost: UInt32 = 0x1 << 1
    static let ground: UInt32 = 0x1 << 2
    static let wall: UInt32 = 0x1 << 3
    static let Score: UInt32 = 0x1 << 4
}

struct PlayerScore {
    
     static var numberOfCoinsCollected = Int()
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var audioPlayerCollision = AVAudioPlayer()
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    var playSound = SKAction()
    var playJumpSound = SKAction()
    var ground = SKSpriteNode()
    var ghost = SKSpriteNode()
    var wallPair = SKNode()
    var moveAndRemove = SKAction()
    var gameStarted = Bool()
    var score = Int()
    var highScore = Int()
    var died = Bool()
    var restartButton = SKSpriteNode()
    var upgradeButton = SKSpriteNode()
    var numberOfCoins = SKSpriteNode()
    var highScoreLabel = SKLabelNode()
    let scoreLabel = SKLabelNode()
    let numberofCoinsLabel = SKLabelNode()
    
    func restartScene() {
        
        self.removeAllChildren()
        self.removeAllActions()
        died = false
        gameStarted = false
        score = 0
        createScene()
    }
    
    func createScene() {
        
        self.physicsWorld.contactDelegate = self
        for i in 0..<2 {
            let background = SKSpriteNode(imageNamed: "Background")
            background.anchorPoint = CGPoint.zero
            background.position = CGPoint(x: -CGFloat(i) * self.frame.width, y: 0)
            background.name = "background"
            background.size = (self.view?.bounds.size)!
            self.addChild(background)
        }
        
        scoreLabel.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 + self.frame.height / 2.5)
        scoreLabel.text = "\(score)"
        scoreLabel.fontName = "04b_19"
        scoreLabel.fontSize = 60
        scoreLabel.zPosition = 5
        self.addChild(scoreLabel)
        
        
        ground = SKSpriteNode(imageNamed: "Ground")
        ground.setScale(0.5)
        ground.position = CGPoint(x: self.frame.width / 2, y: 0 + ground.frame.height / 2)
        ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size)
        ground.physicsBody?.categoryBitMask = (PhysicsStruct.ground)
        ground.physicsBody?.collisionBitMask = (PhysicsStruct.ghost)
        ground.physicsBody?.contactTestBitMask = (PhysicsStruct.ghost)
        ground.physicsBody?.affectedByGravity = false
        ground.physicsBody?.isDynamic = false
        ground.zPosition = 3
        self.addChild(ground)
        
        ghost = SKSpriteNode(imageNamed: "Ghost")
        ghost.size = CGSize(width: 60, height: 70)
        ghost.position = CGPoint(x: self.frame.width / 2 - ghost.frame.width, y: self.frame.height / 2)
        ghost.physicsBody = SKPhysicsBody(circleOfRadius: ghost.size.width/2)
        ghost.physicsBody?.categoryBitMask = (PhysicsStruct.ghost)
        ghost.physicsBody?.collisionBitMask = (PhysicsStruct.ground | PhysicsStruct.wall)
        ghost.physicsBody?.contactTestBitMask = (PhysicsStruct.ground | PhysicsStruct.wall | PhysicsStruct.Score)
        ghost.physicsBody?.affectedByGravity = false
        ghost.physicsBody?.isDynamic = true
        ghost.zPosition = 2
        self.addChild(ghost)
        
        
        
    }
    
    override func didMove(to view: SKView) {
        
        let highScoreDefult = UserDefaults.standard
        let getCoinsCollected = UserDefaults.standard
        
        if(highScoreDefult.value(forKey: "HighScore") != nil) {
            highScore = highScoreDefult.value(forKey: "HighScore") as! Int
            highScoreLabel.text = "HIGH SCORE: \(self.highScore)"
        }
        
        if(getCoinsCollected.value(forKey: "numberOfCoinsCollected") != nil) {
            PlayerScore.numberOfCoinsCollected = getCoinsCollected.value(forKey: "numberOfCoinsCollected") as! Int
            numberofCoinsLabel.text = "\(PlayerScore.numberOfCoinsCollected)"
        }
        
        do {
            self.audioPlayerCollision = try AVAudioPlayer(contentsOf: URL.init(string: Bundle.main.path(forResource: "Collision", ofType: "mp3")!)!)
            self.audioPlayerCollision.prepareToPlay()
            
            
        } catch {
            print(error)
        }
        playSound =  SKAction.playSoundFileNamed("collect", waitForCompletion: false)
        playJumpSound = SKAction.playSoundFileNamed("jumpplayer", waitForCompletion: false)
        
        
        self.createScene()
        
    }
    
    
    func createButtonandLabels() {
        
        numberofCoinsLabel.text = "\(PlayerScore.numberOfCoinsCollected)"
        numberofCoinsLabel.isHidden = false
        numberOfCoins.isHidden = false
        audioPlayerCollision.play()
        
        //Creating the Restart Button
        restartButton = SKSpriteNode(imageNamed: "RestartBtn")
        restartButton.size = CGSize(width: 200, height: 100)
        restartButton.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        restartButton.zPosition = 6
        restartButton.setScale(0)
        self.addChild(restartButton)
        
        restartButton.run(SKAction.scale(to: 1.0, duration: 0.3))
        
        
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
        numberOfCoins.zPosition = 6
        numberOfCoins.setScale(0.8)
        self.addChild(numberOfCoins)
        
        numberofCoinsLabel.text = "\(PlayerScore.numberOfCoinsCollected)"
        numberofCoinsLabel.fontName = "04b_19"
        numberofCoinsLabel.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2 - 200)
        numberofCoinsLabel.zPosition = 6
        self.addChild(numberofCoinsLabel)
        
        highScoreLabel = SKLabelNode(fontNamed: "04b_19")
        highScoreLabel.fontColor = UIColor.black
        highScoreLabel.text = "HIGH SCORE: \(self.highScore)"
        highScoreLabel.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 + 90)
        highScoreLabel.zPosition =  6
        self.addChild(highScoreLabel)
        
        //Creating the Upgrade Button
        upgradeButton = SKSpriteNode(imageNamed: "PowerUpButton")
        upgradeButton.size = CGSize(width: 60, height: 58)
        upgradeButton.position = CGPoint(x: self.frame.width/2 + 140, y: self.frame.height / 2 + 290)
        upgradeButton.zPosition = 6
        self.addChild(upgradeButton)
        
        
    }
    
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        if(died == false) {
            //Test which objects collided
            let firstBody = contact.bodyA
            let secondBody = contact.bodyB
            
            if(firstBody.categoryBitMask == PhysicsStruct.Score && secondBody.categoryBitMask == PhysicsStruct.ghost) {
                
                self.score += 1
                PlayerScore.numberOfCoinsCollected += 1
                scoreLabel.text = "\(score)"
                firstBody.node?.removeFromParent()
                self.run(playSound)
                
                if(score > highScore) {
                    highScore = score
                }
                
                let highScoreDefult = UserDefaults.standard
                highScoreDefult.set(highScore, forKey: "HighScore")
                highScoreDefult.synchronize()
                
                let getCoinsCollected = UserDefaults.standard
                getCoinsCollected.set(PlayerScore.numberOfCoinsCollected, forKey: "numberOfCoinsCollected")
                getCoinsCollected.synchronize()
            }
                
            else if(firstBody.categoryBitMask == PhysicsStruct.ghost && secondBody.categoryBitMask == PhysicsStruct.Score) {
                
                self.score += 1
                PlayerScore.numberOfCoinsCollected += 1
                scoreLabel.text = "\(score)"
                secondBody.node?.removeFromParent()
                self.run(playSound)
                
                if(score > highScore) {
                    highScore = score
                }
                
                let highScoreDefult = UserDefaults.standard
                highScoreDefult.set(highScore, forKey: "HighScore")
                highScoreDefult.synchronize()
                
                let getCoinsCollected = UserDefaults.standard
                getCoinsCollected.set(PlayerScore.numberOfCoinsCollected, forKey: "numberOfCoinsCollected")
                getCoinsCollected.synchronize()
            }
                
            else if(firstBody.categoryBitMask == PhysicsStruct.ghost && secondBody.categoryBitMask == PhysicsStruct.wall ||
                firstBody.categoryBitMask == PhysicsStruct.wall && secondBody.categoryBitMask == PhysicsStruct.ghost) {
                
                enumerateChildNodes(withName: "wallPair", using: ( {
                    (node, error) in
                    
                    node.speed = 0
                    self.removeAllActions()
                    
                }))
                if(died == false) {
                    died = true
                    createButtonandLabels()
                }
            }
                
            else if(firstBody.categoryBitMask == PhysicsStruct.ghost && secondBody.categoryBitMask == PhysicsStruct.ground ||
                firstBody.categoryBitMask == PhysicsStruct.ground && secondBody.categoryBitMask == PhysicsStruct.ghost) {
                
                
                enumerateChildNodes(withName: "wallPair", using: ( {
                    (node, error) in
                    
                    node.speed = 0
                    self.removeAllActions()
                    
                }))
                if(died == false) {
                    died = true
                    createButtonandLabels()
                }
            }
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (gameStarted == false) {
            
            gameStarted = true
            numberOfCoins.isHidden = true
            numberofCoinsLabel.isHidden = true
            ghost.physicsBody?.affectedByGravity = true
            
            let spawn = SKAction.run( {
                () in
                
                self.createWalls()
            })
            
            let delay = SKAction.wait(forDuration: 1.5)
            let SpawnDelay = SKAction.sequence([spawn, delay])
            let spawnDelayForever = SKAction.repeatForever(SpawnDelay)
            self.run(spawnDelayForever)
            
            let distance = CGFloat(self.frame.width + wallPair.frame.width)
            let movePipes = SKAction.moveBy(x: -distance - 50, y: 0, duration: TimeInterval(0.008 * distance))
            let removePipes = SKAction.removeFromParent()
            moveAndRemove = SKAction.sequence([movePipes ,removePipes])
            self.run(playJumpSound)
            ghost.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            ghost.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 65))
            
        } else {
            
            if(died == false) {
                
                ghost.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                ghost.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 65))
                self.run(playJumpSound)
                
            }
            
        }
        
        //If restartButton is clicked
        for touch in touches {
            let location = touch.location(in: self)
            if(died == true) {
                if(restartButton.contains(location)) {
                    restartScene()
                }
            }
        }
        
        //If upgradeButton is clicked
        for touch in touches {
            let location = touch.location(in: self)
            if(died == true) {
                if(upgradeButton.contains(location)) {
                    //load the new scene
                    let upgradeSceneload = GameScene(fileNamed: "UpgradesScene")
                    self.scene?.view?.presentScene(upgradeSceneload!, transition: SKTransition.crossFade(withDuration: 0.5))
                }
            }
        }
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        
        // Called before each frame is rendered
        if(gameStarted == true) {
            if(died == false) {
                enumerateChildNodes(withName: "background", using: ({
                    (node, error) in
                    
                    let bg = node as! SKSpriteNode
                    bg.position = CGPoint(x: bg.position.x - 2, y: bg.position.y)
                    
                    if(bg.position.x <= -bg.size.width) {
                        bg.position = CGPoint(x: bg.position.x + bg.size.width * 2, y: bg.position.y)
                    }
                }))
            }
        }
    }
    
    func createWalls() {
        
        let scoreNode = SKSpriteNode(imageNamed: "Coin")
        scoreNode.size = CGSize(width: 50, height: 50)
        scoreNode.position = CGPoint(x: self.frame.width + 25, y: self.frame.height / 2)
        scoreNode.physicsBody = SKPhysicsBody(rectangleOf: scoreNode.size)
        scoreNode.physicsBody?.affectedByGravity = false
        scoreNode.physicsBody?.isDynamic = false
        scoreNode.physicsBody?.categoryBitMask = PhysicsStruct.Score
        scoreNode.physicsBody?.collisionBitMask = 0
        scoreNode.physicsBody?.contactTestBitMask = PhysicsStruct.ghost
        
        
        wallPair = SKNode()
        wallPair.name = "wallPair"
        let topWall = SKSpriteNode(imageNamed: "Wall")
        let bottomWall = SKSpriteNode(imageNamed: "Wall")
        topWall.position = CGPoint(x: self.frame.width + 25, y: self.frame.height / 2 + 350)
        topWall.physicsBody = SKPhysicsBody(rectangleOf: topWall.size)
        topWall.physicsBody?.categoryBitMask = PhysicsStruct.wall
        topWall.physicsBody?.collisionBitMask = PhysicsStruct.ghost
        topWall.physicsBody?.contactTestBitMask = PhysicsStruct.ghost
        topWall.physicsBody?.isDynamic = false
        topWall.physicsBody?.affectedByGravity = false
        
        bottomWall.position = CGPoint(x: self.frame.width + 25, y: self.frame.height / 2 - 350)
        bottomWall.physicsBody = SKPhysicsBody(rectangleOf: bottomWall.size)
        bottomWall.physicsBody?.categoryBitMask = PhysicsStruct.wall
        bottomWall.physicsBody?.collisionBitMask = PhysicsStruct.ghost
        bottomWall.physicsBody?.contactTestBitMask = PhysicsStruct.ghost
        bottomWall.physicsBody?.isDynamic = false
        bottomWall.physicsBody?.affectedByGravity = false
        
        
        topWall.setScale(0.5)
        bottomWall.setScale(0.5)
        
        topWall.zRotation = CGFloat(Double.pi)
        wallPair.addChild(topWall)
        wallPair.addChild(bottomWall)
        wallPair.zPosition = 1
        let randomPosition = CGFloat.randomRange(min: -200, max: 200)
        wallPair.position.y = wallPair.position.y + randomPosition
        wallPair.addChild(scoreNode)
        wallPair.run(moveAndRemove)
        self.addChild(wallPair)
    }
    
    
}

