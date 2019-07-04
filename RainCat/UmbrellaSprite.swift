//
//  UmbrellaSprite.swift
//  RainCat
//
//  Created by Jake Foster on 6/20/19.
//  Copyright © 2019 Thirteen23. All rights reserved.
//

import SpriteKit

public class UmbrellaSprite: SKSpriteNode {
    private var destination: CGPoint!
    private let easing: CGFloat = 0.1

    public static func newInstance() -> UmbrellaSprite {
        let umbrella = UmbrellaSprite(imageNamed: "umbrella")
        
        let path = UIBezierPath()
        path.move(to: CGPoint())
        path.addLine(to: CGPoint(x: -umbrella.size.width / 2 - 30, y: 0))
        path.addLine(to: CGPoint(x: 0, y: umbrella.size.height / 2))
        path.addLine(to: CGPoint(x: umbrella.size.width / 2 + 30, y: 0))

        umbrella.physicsBody = .init(polygonFrom: path.cgPath)
        umbrella.physicsBody?.isDynamic = false
        umbrella.physicsBody?.restitution = 0.9

        return umbrella
    }
    
    public func updatePosition(_ point: CGPoint) {
        position = point
        destination = point
    }
    
    public func setDestination(_ destination: CGPoint) {
        self.destination = destination
    }
    
    public func update(deltaTime: TimeInterval) {
        let xDiff = destination.x - position.x
        let yDiff = destination.y - position.y
        let distance = sqrt(pow(xDiff, 2) + pow(yDiff, 2))

        if distance > 1 {
            position.x += xDiff * easing
            position.y += yDiff * easing
        } else {
            position = destination
        }
    }
}
