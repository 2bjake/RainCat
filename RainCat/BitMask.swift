//
//  BitMask
//  RainCat
//
//  Created by Jake Foster on 6/20/19.
//  Copyright © 2019 Thirteen23. All rights reserved.
//

import SpriteKit

typealias BitMask = UInt32

extension SKPhysicsBody {
    func isCategory(_ category: BitMask) -> Bool {
        return categoryBitMask == category
    }
}

extension SKPhysicsContact {
    func hasCategory(_ category: BitMask) -> Bool {
        return mainBodyAs(category) != nil
    }

    func mainBodyAs(_ category: BitMask) -> (main: SKPhysicsBody, other: SKPhysicsBody)? {
        if bodyA.isCategory(category) {
            return (bodyA, bodyB)
        } else if bodyB.isCategory(category) {
            return (bodyB, bodyA)
        } else {
            return nil
        }
    }

    func firstBodyAs(_ category: BitMask) -> SKPhysicsBody? {
        if let (main, _) = mainBodyAs(category) {
            return main
        } else {
            return nil
        }
    }
}

/// Game specific code

extension BitMask {
    init(shift: Int) {
        self.init(0x1 << shift)
    }

    static let world = BitMask(shift: 1)
    static let raindrop = BitMask(shift: 2)
    static let floor = BitMask(shift: 3)
    static let cat = BitMask(shift: 4)
    static let food = BitMask(shift: 5)
}

extension BitMask {
    var categoryName: String {
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
            return "unknown (\(self))"
        }
    }
}
