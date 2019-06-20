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
        return self.category == category
    }

    var category: Category {
        return Category(bitMask: categoryBitMask)
    }
}

extension SKPhysicsContact {
    func hasCategory(_ category: Category) -> Bool {
        return mainBodyAs(category) != nil
    }

    func mainBodyAs(_ category: Category) -> (main: SKPhysicsBody, other: SKPhysicsBody)? {
        if bodyA.isCategory(category) {
            return (bodyA, bodyB)
        } else if bodyB.isCategory(category) {
            return (bodyB, bodyA)
        } else {
            return nil
        }
    }

    func firstBodyAs(_ category: Category) -> SKPhysicsBody? {
        if let (main, _) = mainBodyAs(category) {
            return main
        } else {
            return nil
        }
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

extension Category: CustomStringConvertible {
    var description: String {
        switch self {
        case .world:
            return "world"
        case .raindrop:
            return "raindrop"
        case .floor:
            return "floor"
        case .cat:
            return "cat"
        case .food:
            return "food"
        default:
            return String(bitMask)
        }
    }


}
