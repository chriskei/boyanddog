//
//  MenuScene.swift
//  BoyAndDog
//
//  Created by Christopher Kei on 2/21/26.
//

import SpriteKit

class MenuScene : SKScene {
    let startButtonTexture = SKTexture(imageNamed: "button_start")
    let startButtonPressedTexture = SKTexture(imageNamed: "button_start_pressed")
    let logoSprite = SKSpriteNode(imageNamed: "logo")
    let highScoreNode = SKLabelNode(fontNamed: FontName)
    
    var startButton : SKSpriteNode! = nil
    var selectedButton : SKSpriteNode?
    
    override func sceneDidLoad() {
        backgroundColor = SKColor(red: 0.30, green: 0.81, blue: 0.89, alpha: 1.0)
        
        logoSprite.position = CGPoint(x: size.width / 2, y: size.height / 2 + 100)
        logoSprite.scale(to: CGSize(width: size.width * 1.5, height: size.height / 2))
        addChild(logoSprite)
        
        startButton = SKSpriteNode(texture: startButtonTexture)
        startButton.position = CGPoint(x: size.width / 2, y: size.height / 2 - startButton.size.height)
        addChild(startButton)
        
        let defaults = UserDefaults.standard
        let highScore = defaults.integer(forKey: ScoreKey)
        
        highScoreNode.text = "\(highScore)"
        highScoreNode.fontSize = 90
        highScoreNode.verticalAlignmentMode = .top
        highScoreNode.position = CGPoint(x: size.width / 2, y: startButton.position.y - startButton.size.height / 2 - 50)
        highScoreNode.zPosition = 1
        addChild(highScoreNode)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if selectedButton != nil {
                handleStartButtonHover(isHovering: false)
            }
            
            if startButton.contains(touch.location(in: self)) {
                selectedButton = startButton
                handleStartButtonHover(isHovering: true)
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if selectedButton == startButton {
                handleStartButtonHover(isHovering: startButton.contains(touch.location(in: self)))
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if selectedButton == startButton {
                handleStartButtonHover(isHovering: false)
            }
            
            if startButton.contains(touch.location(in: self)) {
                handleStartButtonClick()
            }
        }
        
        selectedButton = nil
    }
    
    func handleStartButtonHover(isHovering : Bool) {
        if isHovering {
            startButton.texture = startButtonPressedTexture
        } else {
            startButton.texture = startButtonTexture
        }
    }
    
    func handleStartButtonClick() {
        let transition = SKTransition.reveal(with: .down, duration: 0.75)
        let gameScene = GameScene(size: size)
        gameScene.scaleMode = scaleMode
        
        view?.presentScene(gameScene, transition: transition)
    }
}
