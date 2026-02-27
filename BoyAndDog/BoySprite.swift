//
//  BoySprite.swift
//  BoyAndDog
//
//  Created by Christopher Kei on 2/20/26.
//

import SpriteKit

public class BoySprite : SKSpriteNode {
    private let movementSpeed : CGFloat = 200
    private let walkingActionKey = "action_walking"
    private let walkFrames = [
        SKTexture(imageNamed: "boy_right"),
        SKTexture(imageNamed: "boy_right_2"),
        SKTexture(imageNamed: "boy_left"),
        SKTexture(imageNamed: "boy_left_2")
    ]
    
    private var boyMovingRight : Bool = true
    
    public static func newInstance() -> BoySprite {
        let boySprite = BoySprite(imageNamed: "boy")
        
        boySprite.zPosition = 1
        // Image is size 54x68, but make the physics box a little smaller for leniency
        boySprite.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 44, height: 58))
        boySprite.physicsBody?.categoryBitMask = BoyCategory
        boySprite.physicsBody?.contactTestBitMask = ChocolateCategory | BrickCategory
        boySprite.physicsBody?.allowsRotation = false
        
        return boySprite
    }
    
    public func setBoyMovingRight(newBoyMovingRightValue: Bool) {
        boyMovingRight = newBoyMovingRightValue
    }
    
    public func update(deltaTime : TimeInterval) {
        if action(forKey: walkingActionKey) == nil {
            let walkingAction = SKAction.repeatForever(
                SKAction.animate(with: walkFrames, timePerFrame: 0.1, resize: true, restore: true)
            )
            
            run(walkingAction, withKey: walkingActionKey)
        }
        
        if boyMovingRight {
            physicsBody?.velocity.dx = movementSpeed
            xScale = 1
        } else {
            physicsBody?.velocity.dx = -movementSpeed
            xScale = -1
        }
    }
}
