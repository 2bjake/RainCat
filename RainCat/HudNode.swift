//
//  HudNode.swift
//  RainCat
//
//  Created by Jake Foster on 6/20/19.
//  Copyright © 2019 Thirteen23. All rights reserved.
//

import SpriteKit

class HudNode: SKNode {
    private let scoreNode = SKLabelNode(fontNamed: Constants.fontName)
    private(set) var score = 0
    private var highScore = 0
    private var showingHighScore = false
    private(set) var quitButtonPressed = false

    private var defaults: UserDefaults { return .standard }

    private let quitButtonTexture = SKTexture(imageNamed: "quit_button")
    private let quitButtonPressedTexture = SKTexture(imageNamed: "quit_button_pressed")
    private lazy var quitButton: SKSpriteNode = { .init(texture: quitButtonTexture) }()

    public func setup(size: CGSize) {
        highScore = defaults.integer(forKey: Constants.scoreKey)
        scoreNode.fontSize = 70
        scoreNode.position = .init(x: size.width / 2, y: size.height - 100)
        scoreNode.zPosition = 1
        addChild(scoreNode)

        let margin = CGFloat(15)
        quitButton.position = CGPoint(x: size.width - quitButton.size.width - margin, y: size.height - margin)
        quitButton.zPosition = 1000
        addChild(quitButton)
    }

    public func addPoint() {
        score += 1
        updateScoreboard()

        if score > highScore {
            defaults.set(score, forKey: Constants.scoreKey)
            if !showingHighScore {
                showingHighScore = true
                scoreNode.run(.scale(to: 1.5, duration: 0.25))
                scoreNode.fontColor = SKColor(red: 0.99, green: 0.92, blue: 0.55, alpha: 1.0)
            }
        }
    }

    public func resetPoints() {
        score = 0
        updateScoreboard()

        if showingHighScore {
            showingHighScore = false
            scoreNode.run(.scale(to: 1.0, duration: 0.25))
            scoreNode.fontColor = .white
        }
    }

    private func updateScoreboard() {
        scoreNode.text = String(score)
    }

    func touchBeganAtPoint(_ point: CGPoint) {
        let containsPoint = quitButton.contains(point)
        quitButtonPressed = containsPoint
        quitButton.texture = containsPoint ? quitButtonPressedTexture : quitButtonTexture
    }

    func touchMovedToPoint(_ point: CGPoint) {
        if !quitButton.contains(point) {
            quitButton.texture = quitButtonTexture
            quitButtonPressed = false
        }
    }

    func touchEndedAtPoint(_ point: CGPoint, action: () -> ()) {
        if quitButton.contains(point) && quitButtonPressed {
            action()
        }
    }
}
