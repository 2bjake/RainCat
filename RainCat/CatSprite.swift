//
//  CatSprite.swift
//  RainCat
//
//  Created by Jake Foster on 6/20/19.
//  Copyright © 2019 Thirteen23. All rights reserved.
//

import SpriteKit

public class CatSprite: SKSpriteNode {
    private let movementSpeed = CGFloat(300) //100 original

    private var timeSinceLastHit = TimeInterval(2)
    private let maxFlailTime = TimeInterval(2)
    private var isFlailing: Bool {
        return timeSinceLastHit < maxFlailTime
    }

    private let rotateActionKey = "action_rotate"
    private let walkingActionKey = "action_walking"
    private let meowActionKey = "action_meow"

    private let walkFrames = [
        SKTexture(imageNamed: "cat_one"),
        SKTexture(imageNamed: "cat_two")
    ]

    private let meowSFX = [
        "cat_meow_1.mp3",
        "cat_meow_2.mp3",
        "cat_meow_4.mp3",
        "cat_meow_6.wav"
    ]

    public static func newInstance() -> CatSprite {
        let catSprite = CatSprite(imageNamed: "cat_one")
        catSprite.zPosition = 5

        catSprite.physicsBody = .init(circleOfRadius: catSprite.size.width / 2)
        catSprite.physicsBody?.categoryBitMask = BitMask(.cat)
        catSprite.physicsBody?.contactTestBitMask = BitMask(.raindrop | .world)
        return catSprite
    }

    public func hitByRain() {
        defer { timeSinceLastHit = 0 }
        removeAction(forKey: walkingActionKey)

        guard !isFlailing && !SoundManager.sharedInstance.isMuted && action(forKey: meowActionKey) == nil else { return }
        run(.playSoundFileNamed(meowSFX.randomElement()!, waitForCompletion: true), withKey: meowActionKey)
    }

    public func update(deltaTime: TimeInterval, foodLocation: CGPoint) {
        timeSinceLastHit += deltaTime

        guard !isFlailing else {
            // still flailing, do nothing
            return
        }

        // fix rotation if cat is not flailing
        if zRotation != 0 && action(forKey: rotateActionKey) == nil {
            run(.rotate(toAngle: 0, duration: 0.25), withKey: rotateActionKey)
        }

        physicsBody?.angularVelocity = 0

        guard abs(foodLocation.x - position.x) > size.width / 2 else {
            // cat close enough to the food, stop walking
            physicsBody?.velocity.dx = 0
            removeAction(forKey: walkingActionKey)
            texture = walkFrames[1]
            return
        }

        // cat is on the way to the food, start walking animation
        if action(forKey: walkingActionKey) == nil {
            let walkingAction = SKAction.repeatForever(.animate(with: walkFrames, timePerFrame: 0.1, resize: false, restore: true))
            run(walkingAction, withKey: walkingActionKey)
        }

        // move cat towards food
        if foodLocation.x < position.x {
            physicsBody?.velocity.dx = -movementSpeed
            xScale = -1 // flip cat sprite to face left
        } else {
            physicsBody?.velocity.dx = movementSpeed
            xScale = 1
        }


    }
}
