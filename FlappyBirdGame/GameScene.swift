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
    static let temp_grav: UInt32 = 0x1 << 5
}

struct hasGameStarted {
    static var gameStarted = Bool()
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
    var scoreNode = SKSpriteNode()
    var moveAndRemove = SKAction()
    var score = Int()
    var highScore = Int()
    var died = Bool()
    var restartButton = SKSpriteNode()
    var upgradeButton = SKSpriteNode()
    var numberOfCoins = SKSpriteNode()
    var topWall = SKSpriteNode()
    var bottomWall = SKSpriteNode()
    var highScoreLabel = SKLabelNode()
    var shieldPwrUp = SKSpriteNode()
    var numberOfShieldsLabel = SKLabelNode()
    var magnetPowerUp = SKSpriteNode()
    var numberOfMagnetsLabel = SKLabelNode()
    var isDeactivated = Bool()
    var isMagnetic = Bool()
    var shieldTimer = Timer()
    var magTimer = Timer()
    var tempGravity = SKFieldNode()
    
    let texture = [SKTexture(imageNamed: "Background"), SKTexture(imageNamed: "Ground"), SKTexture(imageNamed: "Ghost"), SKTexture(imageNamed: "shieldPowerUp"), SKTexture(imageNamed: "magnetIcon"), SKTexture(imageNamed: "RestartBtn"), SKTexture(imageNamed: "CoinIcon"), SKTexture(imageNamed: "PowerUpButton"), SKTexture(imageNamed: "Coin"), SKTexture(imageNamed: "Wall"), SKTexture(imageNamed: "Coin_spin-1"), SKTexture(imageNamed: "Coin_spin-2"), SKTexture(imageNamed: "Coin_spin-3")]
    
    let scoreLabel = SKLabelNode()
    let numberofCoinsLabel = SKLabelNode()
    
    func restartScene() {
        
        self.removeAllChildren()
        self.removeAllActions()
        died = false
        hasGameStarted.gameStarted = false
        score = 0
        isDeactivated = false
        isMagnetic = false
        
        let startScene = GameScene(fileNamed: "StartScene")
        self.scene?.view?.presentScene(startScene!, transition: SKTransition.crossFade(withDuration: 0.5))

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
        
        if(!isDeactivated) {
            
            ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size)
            ground.physicsBody?.categoryBitMask = (PhysicsStruct.ground)
            ground.physicsBody?.collisionBitMask = (PhysicsStruct.ghost)
            ground.physicsBody?.contactTestBitMask = (PhysicsStruct.ghost)
            ground.physicsBody?.affectedByGravity = false
            ground.physicsBody?.isDynamic = false
            
        }
        
        ground.zPosition = 3
        self.addChild(ground)
        
        ghost = SKSpriteNode(imageNamed: "Ghost")
        ghost.size = CGSize(width: 60, height: 70)
        ghost.position = CGPoint(x: self.frame.width / 2 - ghost.frame.width, y: self.frame.height / 2)
        ghost.physicsBody = SKPhysicsBody(circleOfRadius: ghost.size.width/2)
        ghost.physicsBody?.categoryBitMask = (PhysicsStruct.ghost)
        ghost.physicsBody?.collisionBitMask = (PhysicsStruct.ground | PhysicsStruct.wall)
        ghost.physicsBody?.contactTestBitMask = (PhysicsStruct.ground | PhysicsStruct.wall | PhysicsStruct.Score)
        ghost.physicsBody?.fieldBitMask = 0
        ghost.physicsBody?.affectedByGravity = false
        ghost.physicsBody?.isDynamic = true
        ghost.zPosition = 2
        self.addChild(ghost)
        
        
        
        //Add a gravity field to the ghost (player) and have coins physics body react to player's gravityField
        tempGravity = SKFieldNode.radialGravityField()
        tempGravity.position = CGPoint(x: ghost.position.x, y: ghost.position.y)
        tempGravity.strength = 9.8
        tempGravity.categoryBitMask = PhysicsStruct.temp_grav
        tempGravity.isEnabled = false
        self.addChild(tempGravity)
        
        //Create the power ups icons to tell how many the user has purchased
        shieldPwrUp = SKSpriteNode(imageNamed: "shieldPowerUp")
        shieldPwrUp.size = CGSize(width: 256, height: 256)
        shieldPwrUp.position = CGPoint(x: 30, y: 100)
        shieldPwrUp.setScale(0.17)
        shieldPwrUp.zPosition = 6
        self.addChild(shieldPwrUp)
        
        
        numberOfShieldsLabel.text = "\(powerUpClicked.shieldCount)"
        numberOfShieldsLabel.fontName = "04b_19"
        numberOfShieldsLabel.fontSize = 20
        numberOfShieldsLabel.position = CGPoint(x: 30, y: 55)
        numberOfShieldsLabel.zPosition = 6
        self.addChild(numberOfShieldsLabel)
        
        
        magnetPowerUp = SKSpriteNode(imageNamed: "magnetIcon")
        magnetPowerUp.size = CGSize(width: 256, height: 256)
        magnetPowerUp.position = CGPoint(x: 90, y: 100)
        magnetPowerUp.setScale(0.17)
        magnetPowerUp.zPosition = 6
        self.addChild(magnetPowerUp)
        
        numberOfMagnetsLabel.text = "\(powerUpClicked.magnetCount)"
        numberOfMagnetsLabel.fontName = "04b_19"
        numberOfMagnetsLabel.fontSize = 20
        numberOfMagnetsLabel.position = CGPoint(x: 90, y: 55)
        numberOfMagnetsLabel.zPosition = 6
        self.addChild(numberOfMagnetsLabel)
        
        numberOfCoins.isHidden = true
        numberofCoinsLabel.isHidden = true
        ghost.physicsBody?.affectedByGravity = true
        
        if(hasGameStarted.gameStarted == true) {
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
        }
        
        
    }
    
    
    
    override func didMove(to view: SKView) {
        
        SKTexture.preload(texture, withCompletionHandler: {})
        
        print(UIFont.familyNames)
        
        let highScoreDefult = UserDefaults.standard
        let getCoinsCollected = UserDefaults.standard
        let magPowerUpsSaved = UserDefaults.standard
        let shieldPowerUpsSaved = UserDefaults.standard
        
        
        if(highScoreDefult.value(forKey: "HighScore") != nil) {
            
            highScore = highScoreDefult.value(forKey: "HighScore") as! Int
            highScoreLabel.text = "HIGH SCORE: \(self.highScore)"
        }
        
        
        if(getCoinsCollected.value(forKey: "numberOfCoinsCollected") != nil) {
            
            PlayerScore.numberOfCoinsCollected = getCoinsCollected.value(forKey: "numberOfCoinsCollected") as! Int
            numberofCoinsLabel.text = "\(PlayerScore.numberOfCoinsCollected)"
            
        }
        
        if(shieldPowerUpsSaved.value(forKey: "NumberOfShieldCountBought") != nil) {
            
            powerUpClicked.shieldCount = shieldPowerUpsSaved.value(forKey: "NumberOfShieldCountBought") as! Int
            numberOfShieldsLabel.text = "\(powerUpClicked.shieldCount)"
            
        }
        
        if(magPowerUpsSaved.value(forKey: "NumberOfMagnetsCountBought") != nil) {
            
            powerUpClicked.magnetCount = magPowerUpsSaved.value(forKey: "NumberOfMagnetsCountBought") as! Int
            numberOfMagnetsLabel.text = "\(powerUpClicked.magnetCount)"
            
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
        
        //Adding GIF animation to Coin
        let frame1 = SKTexture.init(imageNamed: "Coin_spin-1")
        let frame2 = SKTexture.init(imageNamed: "Coin_spin-2")
        let frame3 = SKTexture.init(imageNamed: "Coin_spin-3")

        let frames: [SKTexture] = [frame1, frame2, frame3]
        
        numberOfCoins = SKSpriteNode(imageNamed: "Coin_spin-1")
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
        
        let animation = SKAction.animate(with: frames, timePerFrame: 0.2, resize: false, restore: false)
        numberOfCoins.run(SKAction.repeatForever(animation))
        
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
                
                if(isMagnetic == true) {
                    
                    turnOnMagEffect()
                }
                
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
                
                if(isMagnetic == true) {
                    turnOnMagEffect()
                }
                
                
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
        
        if(died == false) {
            
            ghost.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            ghost.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 65))
            self.run(playJumpSound)
            
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
            
            //Decrement the number of power ups
            if(shieldPwrUp.contains(location)) {
                
                if(died == false) {
                    
                    if(powerUpClicked.shieldCount > 0) {
                        
                        powerUpClicked.shieldCount -= 1
                        
                        let shieldPowerUpsSaved  = UserDefaults.standard
                        shieldPowerUpsSaved.set(powerUpClicked.shieldCount, forKey: "NumberOfShieldCountBought")
                        shieldPowerUpsSaved.synchronize()
                        updateDisplayForPowerUps()
                        isDeactivated = true
                        shieldTimer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(resetPhysics), userInfo: nil, repeats: false)
                        
                    }
                    
                }
                
            }
                
            else if(magnetPowerUp.contains(location)) {
                
                if(died == false) {
                    
                    if(powerUpClicked.magnetCount > 0 && !isMagnetic) {
                        
                        powerUpClicked.magnetCount -= 1
                        let magPowerUpsSaved  = UserDefaults.standard
                        magPowerUpsSaved.set(powerUpClicked.magnetCount, forKey: "NumberOfMagnetsCountBought")
                        magPowerUpsSaved.synchronize()
                        updateDisplayForPowerUps()
                        //Impliment the magnetic effect
                        isMagnetic = true
                        magTimer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(turnOfMagEffect), userInfo: nil, repeats: false)
                        
                    }
                }
            }
        }
    }
    
    
    
    func resetPhysics() {
        
        //Reset Physics
        isDeactivated = false
        
    }
    
    func turnOfMagEffect() {
        
        print("reached")
        isMagnetic = false
        
    }
    
    func turnOnMagEffect() {
        
        tempGravity.isEnabled = true
    }
    
    func updateDisplayForPowerUps() {
        
        numberOfShieldsLabel.text = "\(powerUpClicked.shieldCount)"
        numberOfMagnetsLabel.text = "\(powerUpClicked.magnetCount)"
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        // Called before each frame is rendered
        if(hasGameStarted.gameStarted == true) {
            
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
        
        if(died == true) {
            
            //Cancel the ongoing timers
            if(shieldTimer.isValid) {
                
                shieldTimer.invalidate()
                
            } else if(magTimer.isValid) {
                
                scoreNode.removeFromParent()
                magTimer.invalidate()
                
            }
            
        }
        
        if(isMagnetic && died == false) {
            
            tempGravity.position.x = ghost.position.x
            tempGravity.position.y = ghost.position.y
            
        }
        
        if(hasGameStarted.gameStarted && isDeactivated) {
            
            ground.physicsBody = nil
            topWall.physicsBody = nil
            bottomWall.physicsBody = nil
            
        }
            
        else if(hasGameStarted.gameStarted && !isDeactivated) {
            
            ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size)
            ground.physicsBody?.categoryBitMask = (PhysicsStruct.ground)
            ground.physicsBody?.collisionBitMask = (PhysicsStruct.ghost)
            ground.physicsBody?.contactTestBitMask = (PhysicsStruct.ghost)
            ground.physicsBody?.affectedByGravity = false
            ground.physicsBody?.isDynamic = false
            
            topWall.physicsBody = SKPhysicsBody(rectangleOf: topWall.size)
            topWall.physicsBody?.categoryBitMask = PhysicsStruct.wall
            topWall.physicsBody?.collisionBitMask = PhysicsStruct.ghost
            topWall.physicsBody?.contactTestBitMask = PhysicsStruct.ghost
            topWall.physicsBody?.isDynamic = false
            topWall.physicsBody?.affectedByGravity = false
            
            bottomWall.physicsBody = SKPhysicsBody(rectangleOf: bottomWall.size)
            bottomWall.physicsBody?.categoryBitMask = PhysicsStruct.wall
            bottomWall.physicsBody?.collisionBitMask = PhysicsStruct.ghost
            bottomWall.physicsBody?.contactTestBitMask = PhysicsStruct.ghost
            bottomWall.physicsBody?.isDynamic = false
            bottomWall.physicsBody?.affectedByGravity = false
            
        }
        
    }
    
    func createWalls() {
        
        scoreNode = SKSpriteNode(imageNamed: "Coin")
        scoreNode.size = CGSize(width: 50, height: 50)
        scoreNode.position = CGPoint(x: self.frame.width + 25, y: self.frame.height / 2)
        scoreNode.physicsBody = SKPhysicsBody(rectangleOf: scoreNode.size)
        
        if(isMagnetic && hasGameStarted.gameStarted && died == false) {
            
            scoreNode.physicsBody?.isDynamic = true
            
        } else {
            
            scoreNode.physicsBody?.isDynamic = false
            
        }
        
        scoreNode.physicsBody?.categoryBitMask = PhysicsStruct.Score
        scoreNode.physicsBody?.collisionBitMask = 0
        scoreNode.physicsBody?.contactTestBitMask = PhysicsStruct.ghost
        scoreNode.physicsBody?.fieldBitMask = PhysicsStruct.temp_grav
        scoreNode.name = "coinObject"
        scoreNode.physicsBody?.affectedByGravity = false
        
        wallPair = SKNode()
        wallPair.name = "wallPair"
        topWall = SKSpriteNode(imageNamed: "Wall")
        bottomWall = SKSpriteNode(imageNamed: "Wall")
        topWall.position = CGPoint(x: self.frame.width + 25, y: self.frame.height / 2 + 350)
        
        if(!isDeactivated) {
            
            topWall.physicsBody = SKPhysicsBody(rectangleOf: topWall.size)
            topWall.physicsBody?.categoryBitMask = PhysicsStruct.wall
            topWall.physicsBody?.collisionBitMask = PhysicsStruct.ghost
            topWall.physicsBody?.contactTestBitMask = PhysicsStruct.ghost
            topWall.physicsBody?.isDynamic = false
            topWall.physicsBody?.affectedByGravity = false
            
        }
        
        bottomWall.position = CGPoint(x: self.frame.width + 25, y: self.frame.height / 2 - 350)
        
        if(!isDeactivated) {
            
            bottomWall.physicsBody = SKPhysicsBody(rectangleOf: bottomWall.size)
            bottomWall.physicsBody?.categoryBitMask = PhysicsStruct.wall
            bottomWall.physicsBody?.collisionBitMask = PhysicsStruct.ghost
            bottomWall.physicsBody?.contactTestBitMask = PhysicsStruct.ghost
            bottomWall.physicsBody?.isDynamic = false
            bottomWall.physicsBody?.affectedByGravity = false
            
        }
        
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

