//
//  GameScene.swift
//  FlappyBirdGame
//
//  Created by Pragun Sharma on 27/06/17.
//  Copyright © 2017 Pragun Sharma. All rights reserved.
//

import SpriteKit
import GameplayKit

struct PhysicsStruct {
    static let ghost: UInt32 = 0x1 << 1
    static let ground: UInt32 = 0x1 << 2
    static let wall: UInt32 = 0x1 << 3
}

class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    var ground = SKSpriteNode()
    var ghost = SKSpriteNode()
    override func didMove(to view: SKView) {
        
        ground = SKSpriteNode(imageNamed: "Ground")
        ground.setScale(0.5)
        ground.position = CGPoint(x: self.frame.width/2 - 110 , y: ground.frame.width/2 - 580)
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
        ghost.position = CGPoint(x: 0, y: 0)
        ghost.physicsBody = SKPhysicsBody(circleOfRadius: ghost.frame.height/2)
        ghost.physicsBody?.categoryBitMask = (PhysicsStruct.ghost)
        ghost.physicsBody?.collisionBitMask = (PhysicsStruct.ground | PhysicsStruct.wall)
        ghost.physicsBody?.contactTestBitMask = (PhysicsStruct.ground | PhysicsStruct.wall)
        ghost.physicsBody?.affectedByGravity = true
        ghost.physicsBody?.isDynamic = true
        ghost.zPosition = 2
        self.addChild(ghost)
        
        createWalls()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        ghost.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        ghost.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 120))

    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    func createWalls() {
        
        let wallPair = SKNode()
        let topWall = SKSpriteNode(imageNamed: "Wall")
        let bottomWall = SKSpriteNode(imageNamed: "Wall")
        topWall.position = CGPoint(x: self.frame.width, y: 350)

        topWall.physicsBody = SKPhysicsBody(rectangleOf: topWall.size)
        topWall.physicsBody?.categoryBitMask = PhysicsStruct.wall
        topWall.physicsBody?.collisionBitMask = PhysicsStruct.ghost
        topWall.physicsBody?.contactTestBitMask = PhysicsStruct.ghost
        topWall.physicsBody?.isDynamic = false
        topWall.physicsBody?.affectedByGravity = false
        
        bottomWall.position = CGPoint(x: self.frame.width, y: -350)
        
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
        self.addChild(wallPair)
    }
    
    
}
