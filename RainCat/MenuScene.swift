//
//  MenuScene.swift
//  RainCat
//
//  Created by Jake Foster on 6/20/19.
//  Copyright © 2019 Thirteen23. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene {
    let startButtonTexture = SKTexture(imageNamed: "button_start")
    let startButtonPressedTexture = SKTexture(imageNamed: "button_start_pressed")
    let soundButtonTexture = SKTexture(imageNamed: "speaker_on")
    let soundButtonTextureOff = SKTexture(imageNamed: "speaker_off")

    let logoSprite = SKSpriteNode(imageNamed: "logo")
    lazy var startButton: SKSpriteNode = { .init(texture: startButtonTexture) }()
    lazy var soundButton: SKSpriteNode = {
        .init(texture: SoundManager.sharedInstance.isMuted ? soundButtonTextureOff : soundButtonTexture)

    }()

    var defaults: UserDefaults { return .standard }

    let highScoreNode = SKLabelNode(fontNamed: Constants.fontName)

    var selectedButton: SKSpriteNode?

    override func sceneDidLoad() {
        backgroundColor = SKColor(red:0.30, green:0.81, blue:0.89, alpha:1.0)

        logoSprite.position = CGPoint(x: size.width / 2, y: size.height / 2 + 100)
        addChild(logoSprite)

        startButton.position = CGPoint(x: size.width / 2, y: size.height / 2 - startButton.size.height / 2)
        addChild(startButton)

        let edgeMargin = CGFloat(25)
        soundButton.position = CGPoint(x: size.width - soundButton.size.width / 2 - edgeMargin, y: soundButton.size.height / 2 + edgeMargin)
        addChild(soundButton)

        let highScore = defaults.integer(forKey: Constants.scoreKey)
        highScoreNode.text = String(highScore)
        highScoreNode.fontSize = 90
        highScoreNode.verticalAlignmentMode = .top
        highScoreNode.position = CGPoint(x: size.width / 2, y: startButton.position.y - startButton.size.height / 2 - 50)
        highScoreNode.zPosition = 1
        addChild(highScoreNode)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }

        if selectedButton != nil {
            handleStartButtonHover(isHovering: false)
            handleSoundButtonHover(isHovering: false)
        }

        if startButton.contains(touch.location(in: self)) {
            selectedButton = startButton
            handleStartButtonHover(isHovering: true)
        } else if soundButton.contains(touch.location(in: self)) {
            selectedButton = soundButton
            handleSoundButtonHover(isHovering: true)
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }

        if selectedButton == startButton {
            handleStartButtonHover(isHovering: startButton.contains(touch.location(in: self)))
        } else if selectedButton == soundButton {
            handleSoundButtonHover(isHovering: soundButton.contains(touch.location(in: self)))
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }

        if selectedButton == startButton {
            handleStartButtonHover(isHovering: false)

            if startButton.contains(touch.location(in: self)) {
                handleStartButtonClick()
            }
        } else if selectedButton == soundButton {
            handleSoundButtonHover(isHovering: false)

            if soundButton.contains(touch.location(in: self)) {
                handleSoundButtonClick()
            }
        }
        selectedButton = nil
    }

    private func handleStartButtonHover(isHovering: Bool) {
        startButton.texture = isHovering ? startButtonPressedTexture : startButtonTexture
    }

    private func handleSoundButtonHover(isHovering: Bool) {
        soundButton.alpha = isHovering ? 0.5 : 1.0
    }

    private func handleStartButtonClick() {
        let transition = SKTransition.reveal(with: .down, duration: 0.75)
        let gameScene = GameScene(size: size)
        gameScene.scaleMode = scaleMode
        view?.presentScene(gameScene, transition: transition)
    }

    private func handleSoundButtonClick() {
        SoundManager.sharedInstance.isMuted.toggle()
        soundButton.texture = SoundManager.sharedInstance.isMuted ? soundButtonTextureOff : soundButtonTexture
    }
}
