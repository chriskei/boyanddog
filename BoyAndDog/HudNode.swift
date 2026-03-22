//
//  HudNode.swift
//  BoyAndDog
//
//  Created by Christopher Kei on 2/21/26.
//

import SpriteKit

class HudNode : SKNode {
    private let scoreNode = SKLabelNode(fontNamed: FontName)
    private(set) var score : Int = 0
    private(set) var effectiveScore : Double = 0
    private var highScore : Int = 0
    private var showingHighScore = false
    
    public func setup(size: CGSize) {
        removeAllChildren()
        
        let defaults = UserDefaults.standard
        highScore = defaults.integer(forKey: ScoreKey)
        
        score = 0
        effectiveScore = 0
        showingHighScore = false
        
        scoreNode.text = "\(score)"
        scoreNode.fontSize = 70
        scoreNode.position = CGPoint(x: size.width / 2, y: size.height - 150)
        scoreNode.zPosition = 1
        
        addChild(scoreNode)
    }
    
    public func addPoint(points: Double) {
        effectiveScore += points
        score = Int(effectiveScore.rounded(.down))
        updateScoreboard()
        
        if score > highScore {
            let defaults = UserDefaults.standard
            defaults.set(score, forKey: ScoreKey)
            
            if !showingHighScore {
                showingHighScore = true
                
                scoreNode.run(SKAction.scale(to: 1.5, duration: 0.25))
                scoreNode.fontColor = SKColor.yellow
            }
        }
    }
    
    public func resetPoints() {
        score = 0
        effectiveScore = 0
        updateScoreboard()
        
        if showingHighScore {
            showingHighScore = false
            
            scoreNode.run(SKAction.scale(to: 1.0, duration: 0.25))
            scoreNode.fontColor = SKColor.white
        }
    }
    
    private func updateScoreboard() {
        scoreNode.text = "\(score)"
    }
}
