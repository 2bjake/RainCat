//
//  GameScene.swift
//  RainCat
//
//  Created by Marc Vandehey on 8/29/16.
//  Copyright © 2016 Thirteen23. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {

    // MARK: - Properties

    private var lastUpdateTime = TimeInterval(0)
    private var currentRainDropSpawnTime = TimeInterval(0)
    private var rainDropSpawnRate = TimeInterval(0.5)
    private let foodEdgeMargin = CGFloat(75.0)

    private let raindropTexture = SKTexture(imageNamed: "rain_drop")
    
    private let backgroundNode = BackgroundNode()
    private let umbrellaNode = UmbrellaSprite.newInstance()
    private var catNode: CatSprite?
    private var foodNode: FoodSprite?

    // MARK: - SKScene overrides

    override func sceneDidLoad() {
        self.lastUpdateTime = 0
        backgroundNode.setup(size: size)
        addChild(backgroundNode)
        
        umbrellaNode.updatePosition(CGPoint(x: frame.midX, y: frame.midY))
        umbrellaNode.zPosition = 4
        addChild(umbrellaNode)

        spawnCat()
        spawnFood()
        
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
        if let foodNode = foodNode {
            catNode?.update(deltaTime: dt, foodLocation: foodNode.position)
        }
        
        self.lastUpdateTime = currentTime
    }

    // MARK: - Spawn functions
    
    private func spawnRaindrop() {
        let raindrop = SKSpriteNode(texture: raindropTexture)
        raindrop.physicsBody = SKPhysicsBody(texture: raindropTexture, size: raindrop.size)
        raindrop.physicsBody?.categoryBitMask = BitMask(.raindrop)
        raindrop.physicsBody?.contactTestBitMask = BitMask(.floor | .world)
        raindrop.physicsBody?.density = 0.5
        let xPos = CGFloat.random(in: 0..<size.width)
        let yPos = size.height + raindrop.size.height
        raindrop.position = CGPoint(x: xPos, y: yPos)
        raindrop.zPosition = 2
        addChild(raindrop)
    }

    private func spawnCat() {
        if let currentCat = catNode, children.contains(currentCat) {
            removeNode(currentCat)
        }
        catNode = CatSprite.newInstance()
        catNode?.position = CGPoint(x: umbrellaNode.position.x, y: umbrellaNode.position.y - 30)

        addChild(catNode!)
    }

    private func spawnFood() {
        if let currentFood = foodNode, children.contains(currentFood) {
            removeNode(currentFood)
        }
        var randomPosition = CGFloat.random(in: 0..<(size.width - foodEdgeMargin * 2))

        foodNode = FoodSprite.newInstance()
        foodNode!.position = CGPoint(x: randomPosition + foodEdgeMargin, y: size.height)
        addChild(foodNode!)
    }

    private func removeNode(_ node: SKNode) {
        node.removeFromParent()
        node.removeAllActions()
        node.physicsBody = nil
    }
}

extension GameScene: SKPhysicsContactDelegate {

    private func handleFoodHit(contact: SKPhysicsContact) {
        guard let (food, other) = contact.mainBodyAs(.food) else { return }

        switch other.category {
        case .cat:
            //TODO: increment points
            print("fed cat")
            fallthrough
        case .world:
            food.node?.removeFromParent()
            food.node?.physicsBody = nil
            spawnFood()
        default:
            print("something else touched the food")
        }
    }

    private func handleCatCollision(contact: SKPhysicsContact) {
        guard let (_, other) = contact.mainBodyAs(.cat) else { return }

        switch other.category {
        case .raindrop:
            catNode?.hitByRain()
        case .world:
            spawnCat()
        default:
            print("something hit the cat")
        }
    }

    func didBegin(_ contact: SKPhysicsContact) {
        print("collision between \(contact.bodyA.category) and \(contact.bodyB.category)")
        if let (raindrop, other) = contact.mainBodyAs(.raindrop), other.isCategory(.floor) || other.isCategory(.food){
            raindrop.node?.physicsBody?.collisionBitMask = 0
            raindrop.node?.physicsBody?.categoryBitMask = 0
        }

        if contact.hasCategory(.food) {
            handleFoodHit(contact: contact)
            return
        }

        if contact.hasCategory(.cat) {
            handleCatCollision(contact: contact)
            return
        }

        if let (_, other) = contact.mainBodyAs(.world), let node = other.node {
            removeNode(node)
        }
    }
}
