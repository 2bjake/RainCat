//
//  GameScene.swift
//  RainCat
//
//  Created by Marc Vandehey on 8/29/16.
//  Copyright © 2016 Thirteen23. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    private var lastUpdateTime : TimeInterval = 0
    private var currentRainDropSpawnTime : TimeInterval = 0
    private var rainDropSpawnRate : TimeInterval = 0.5
    private let raindropTexture = SKTexture(imageNamed: "rain_drop")
    
    private let backgroundNode = BackgroundNode()
    private let umbrellaNode = UmbrellaSprite.newInstance()
    private var catNode: CatSprite?

    override func sceneDidLoad() {
        self.lastUpdateTime = 0
        backgroundNode.setup(size: size)
        addChild(backgroundNode)
        
        umbrellaNode.updatePosition(CGPoint(x: frame.midX, y: frame.midY))
        umbrellaNode.zPosition = 4
        addChild(umbrellaNode)

        spawnCat()
        
        var worldFrame = frame
        worldFrame.origin.x -= 100
        worldFrame.origin.y -= 100
        worldFrame.size.height += 200
        worldFrame.size.width += 200
        
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: worldFrame)
        self.physicsBody?.categoryBitMask = BitMask(.world)
        
        self.physicsWorld.contactDelegate = self
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touchPoint = touches.first?.location(in: self) else { return }
        umbrellaNode.setDestination(touchPoint)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touchPoint = touches.first?.location(in: self) else { return }
        umbrellaNode.setDestination(touchPoint)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // Update the Spawn Timer
        currentRainDropSpawnTime += dt
        
        if currentRainDropSpawnTime > rainDropSpawnRate {
            currentRainDropSpawnTime = 0
            spawnRaindrop()
        }
        
        umbrellaNode.update(deltaTime: dt)
        
        self.lastUpdateTime = currentTime
    }
    
    private func spawnRaindrop() {
        let raindrop = SKSpriteNode(texture: raindropTexture)
        raindrop.physicsBody = SKPhysicsBody(texture: raindropTexture, size: raindrop.size)
        raindrop.physicsBody?.categoryBitMask = BitMask(.raindrop)
        raindrop.physicsBody?.contactTestBitMask = BitMask(.floor | .world)
        let xPos = CGFloat.random(in: 0..<size.width)
        let yPos = size.height + raindrop.size.height
        raindrop.position = CGPoint(x: xPos, y: yPos)
        raindrop.zPosition = 2
        addChild(raindrop)
    }

    private func spawnCat() {
        if let currentCat = catNode, children.contains(currentCat) {
            currentCat.removeFromParent()
            currentCat.removeAllActions()
            currentCat.physicsBody = nil
        }
        catNode = CatSprite.newInstance()
        catNode?.position = CGPoint(x: umbrellaNode.position.x, y: umbrellaNode.position.y - 30)

        addChild(catNode!)
    }
}

extension GameScene: SKPhysicsContactDelegate {

    private func handleCatCollision(contact: SKPhysicsContact) {
        guard let (_, other) = contact.mainBodyAs(.cat) else { return }

        switch Category(bitMask: other.categoryBitMask) {
        case .raindrop:
            print("rain hit the cat")
        case .world:
            spawnCat()
        default:
            print("something hit the cat")
        }
    }

    func didBegin(_ contact: SKPhysicsContact) {
        if let raindrop = contact.firstBodyAs(.raindrop) {
            raindrop.node?.physicsBody?.collisionBitMask = 0
            raindrop.node?.physicsBody?.categoryBitMask = 0
        }

        if contact.hasCategory(.cat) {
            handleCatCollision(contact: contact)
            return
        }

        if let (_, other) = contact.mainBodyAs(.world) {
            other.node?.removeFromParent()
            other.node?.physicsBody = nil
            other.node?.removeAllActions()
        }
    }
}
