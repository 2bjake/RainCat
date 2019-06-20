//
//  CatSprite.swift
//  RainCat
//
//  Created by Jake Foster on 6/20/19.
//  Copyright © 2019 Thirteen23. All rights reserved.
//

import SpriteKit

public class CatSprite: SKSpriteNode {
    public static func newInstance() -> CatSprite {
        let catSprite = CatSprite(imageNamed: "cat_one")
        catSprite.zPosition = 5

        catSprite.physicsBody = .init(circleOfRadius: catSprite.size.width / 2)
        catSprite.physicsBody?.categoryBitMask = BitMask(.cat)
        catSprite.physicsBody?.contactTestBitMask = BitMask(.raindrop | .world)
        return catSprite
    }

    public func update(deltaTime: TimeInterval) {
    


    }
}
