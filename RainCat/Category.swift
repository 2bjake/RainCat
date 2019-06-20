//
//  Category.swift
//  RainCat
//
//  Created by Jake Foster on 6/20/19.
//  Copyright © 2019 Thirteen23. All rights reserved.
//

import SpriteKit

typealias BitMask = UInt32

struct Category: Equatable {
    let bitMask: UInt32

    init(bitMask: UInt32) {
        self.bitMask = bitMask
    }

    init(shift: Int) {
        self.bitMask = 0x1 << shift
    }
}

func |(left: Category, right: Category) -> Category {
    return Category(bitMask: left.bitMask | right.bitMask)
}

func &(left: Category, right: Category) -> Category {
    return Category(bitMask: left.bitMask & right.bitMask)
}

extension SKPhysicsBody {
    func isCategory(_ category: Category) -> Bool {
        return self.categoryBitMask == category.bitMask
    }
}

extension SKPhysicsContact {
    func hasCategory(_ category: Category) -> Bool {
        return bodyA.isCategory(category) || bodyB.isCategory(category)
    }
}

extension UInt32 {
    init(_ category: Category) {
        self = category.bitMask
    }
}

/// Game specific code

extension Category {
    static let world = Category(shift: 1)
    static let raindrop = Category(shift: 2)
    static let floor = Category(shift: 3)
    static let cat = Category(shift: 4)
    static let food = Category(shift: 5)
}
