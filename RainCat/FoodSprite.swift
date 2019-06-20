//
//  FoodSprite.swift
//  RainCat
//
//  Created by Jake Foster on 6/20/19.
//  Copyright © 2019 Thirteen23. All rights reserved.
//

import SpriteKit

class FoodSprite: SKSpriteNode {
    public static func newInstance() -> FoodSprite {
        let foodDish = FoodSprite(imageNamed: "food_dish")

        foodDish.physicsBody = .init(rectangleOf: foodDish.size)
        foodDish.physicsBody?.categoryBitMask = BitMask(.food)
        foodDish.physicsBody?.contactTestBitMask = BitMask(.world | .raindrop | .cat)
        foodDish.zPosition = 5

        return foodDish
    }
}
