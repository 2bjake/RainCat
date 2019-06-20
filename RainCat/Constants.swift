//
//  Constants.swift
//  RainCat
//
//  Created by Jake Foster on 6/19/19.
//  Copyright © 2019 Thirteen23. All rights reserved.
//

import Foundation

enum PhysicsCategory {
    static let world: UInt32 = 0x1 << 1
    static let raindrop: UInt32 = 0x1 << 2
    static let floor: UInt32 = 0x1 << 3
}
