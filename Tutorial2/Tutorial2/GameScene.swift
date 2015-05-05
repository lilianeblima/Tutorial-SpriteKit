//
//  GameScene.swift
//  Tutorial2
//
//  Created by Liliane Bezerra Lima on 04/05/15.
//  Copyright (c) 2015 Liliane Bezerra Lima. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let BallCategoryName = "ball"
    let PaddleCategoryName = "paddle"
    let BlockCategoryName = "block"
    let BlockNodeCategoryName = "blockNode"
    
    let BallCategory  :   UInt32 = 0x1 << 0
    let BottomCategory:   UInt32 = 0x1 << 1
    let BlockCategory :   UInt32 = 0x1 << 2
    let PaddleCategory:   UInt32 = 0x1 << 3
    
    var isFingerOnPaddle = false
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        let borderBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        
        borderBody.friction = 0
        
        self.physicsBody = borderBody
        physicsWorld.gravity = CGVectorMake(0, 0)
        physicsWorld.contactDelegate = self
        
        let ball = childNodeWithName(BallCategoryName) as! SKSpriteNode
        ball.physicsBody!.applyImpulse(CGVectorMake(5, -15))
        
        let bottomRect = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 1)
        let bottom = SKNode()
        bottom.physicsBody = SKPhysicsBody(edgeLoopFromRect: bottomRect)
        addChild(bottom)
        
        let paddle = childNodeWithName(PaddleCategoryName) as! SKSpriteNode
        
        bottom.physicsBody!.categoryBitMask = BottomCategory
        ball.physicsBody!.categoryBitMask = BallCategory
        paddle.physicsBody!.categoryBitMask = PaddleCategory
        
        ball.physicsBody!.contactTestBitMask = BottomCategory | BlockCategory
        
        let numberOfBlocks = 10
        let numberOfBlocksC2 = 9
        let numberOfBlocksC3 = 8
        let numberOfBlocksC4 = 5
        
        let blockWidth = SKSpriteNode(imageNamed: "block.png").size.width
        let totalBlocksWidth = blockWidth * CGFloat(numberOfBlocks)

        
        let padding: CGFloat = 10.0
        let totalPadding = padding * CGFloat(numberOfBlocks - 1)

        
        let xOffset = (CGRectGetWidth(frame) - totalBlocksWidth - totalPadding) / 2

        
        for i in 0..<numberOfBlocks {
            let block = SKSpriteNode(imageNamed: "block.png")
            block.position = CGPointMake(xOffset + CGFloat(CGFloat(i) + 0.5)*blockWidth + CGFloat(i-1)*padding, CGRectGetHeight(frame) * 0.95)
            block.physicsBody = SKPhysicsBody(rectangleOfSize: block.frame.size)
            block.physicsBody!.allowsRotation = false
            block.physicsBody!.friction = 0.0
            block.physicsBody!.dynamic = false
            block.physicsBody!.affectedByGravity = false
            block.name = BlockCategoryName
            block.physicsBody!.categoryBitMask = BlockCategory
            addChild(block)
        }
        
        for i in 0..<numberOfBlocksC2 {
            let block = SKSpriteNode(imageNamed: "block.png")
            block.position = CGPointMake(xOffset+1 + CGFloat(CGFloat(i) + 0.5)*blockWidth + CGFloat(i-1)*padding, CGRectGetHeight(frame) * 0.85)
            block.physicsBody = SKPhysicsBody(rectangleOfSize: block.frame.size)
            block.physicsBody!.allowsRotation = false
            block.physicsBody!.friction = 0.0
            block.physicsBody!.dynamic = false
            block.physicsBody!.affectedByGravity = false
            block.name = BlockCategoryName
            block.physicsBody!.categoryBitMask = BlockCategory
            addChild(block)
        }
        
        for i in 0..<numberOfBlocksC3 {
            let block = SKSpriteNode(imageNamed: "block.png")
            block.position = CGPointMake(xOffset+2 + CGFloat(CGFloat(i) + 0.5)*blockWidth + CGFloat(i-1)*padding, CGRectGetHeight(frame) * 0.75)
            block.physicsBody = SKPhysicsBody(rectangleOfSize: block.frame.size)
            block.physicsBody!.allowsRotation = false
            block.physicsBody!.friction = 0.0
            block.physicsBody!.dynamic = false
            block.physicsBody!.affectedByGravity = false
            block.name = BlockCategoryName
            block.physicsBody!.categoryBitMask = BlockCategory
            addChild(block)
        }
        
        for i in 0..<numberOfBlocksC4 {
            let block = SKSpriteNode(imageNamed: "block.png")
            block.position = CGPointMake(xOffset+3 + CGFloat(CGFloat(i) + 0.5)*blockWidth + CGFloat(i-1)*padding, CGRectGetHeight(frame) * 0.65)
            block.physicsBody = SKPhysicsBody(rectangleOfSize: block.frame.size)
            block.physicsBody!.allowsRotation = false
            block.physicsBody!.friction = 0.0
            block.physicsBody!.dynamic = false
            block.physicsBody!.affectedByGravity = false
            block.name = BlockCategoryName
            block.physicsBody!.categoryBitMask = BlockCategory
            addChild(block)
        }
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        var touch = touches.first as! UITouch
        var touchLocation = touch.locationInNode(self)
        
        if let body = physicsWorld.bodyAtPoint(touchLocation) {
            if body.node!.name == PaddleCategoryName {
                println("Began touch on paddle")
                isFingerOnPaddle = true
            }
        }
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        if isFingerOnPaddle {
            var touch = touches.first as! UITouch
            var touchLocation = touch.locationInNode(self)
            var previousLocation = touch.previousLocationInNode(self)
            
            var paddle = childNodeWithName(PaddleCategoryName) as! SKSpriteNode
            
            var paddleX = paddle.position.x + (touchLocation.x - previousLocation.x)
            
            paddleX = max(paddleX, paddle.size.width/2)
            paddleX = min(paddleX, size.width - paddle.size.width/2)
            
            paddle.position = CGPointMake(paddleX, paddle.position.y)
        }
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        isFingerOnPaddle = false
    }
    
    func didBeginContact(contact: SKPhysicsContact){
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if firstBody.categoryBitMask == BallCategory && secondBody.categoryBitMask == BottomCategory {
            println("Hit bottom. First contact has been made.")
            
            
            if let mainView = view {
                let gameOverScene = GameOverScene.unarchiveFromFile("GameOverOverScene") as! GameOverScene
                gameOverScene.gameWon = false
                mainView.presentScene(gameOverScene)
            }
        }
        if firstBody.categoryBitMask == BallCategory && secondBody.categoryBitMask == BlockCategory {
            secondBody.node!.removeFromParent()
            
            if isGameWon() {
                if let mainView = view {
                    let gameOverScene = GameOverScene.unarchiveFromFile("GameOverOverScene") as! GameOverScene
                    gameOverScene.gameWon = true
                    mainView.presentScene(gameOverScene)
                }
            }        }
    }
    
    
    func isGameWon() -> Bool {
        var numberOfBricks = 0
        self.enumerateChildNodesWithName(BlockCategoryName) {
            node, stop in
            numberOfBricks = numberOfBricks + 1
        }
        return numberOfBricks == 0
    }
    
    
    override func update(currentTime: NSTimeInterval) {
        let ball = self.childNodeWithName(BallCategoryName) as! SKSpriteNode
        
        let maxSpeed: CGFloat = 1000.0
        let speed = sqrt(ball.physicsBody!.velocity.dx * ball.physicsBody!.velocity.dx + ball.physicsBody!.velocity.dy * ball.physicsBody!.velocity.dy)
        
        if speed > maxSpeed {
            ball.physicsBody!.linearDamping = 0.4
        }
        else {
            ball.physicsBody!.linearDamping = 0.0
        }
    }
}
