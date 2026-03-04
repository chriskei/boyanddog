//
//  DogSprite.swift
//  BoyAndDog
//
//  Created by Christopher Kei on 2/20/26.
//

import SpriteKit

public class DogSprite : SKSpriteNode {
    private let movementSpeed : CGFloat = 220
    private let walkingActionKey = "action_walking"
    private let walkFrames = [
        SKTexture(imageNamed: "dog")
    ]
    
    private var dogMovingRight : Bool = true
    
    public static func newInstance() -> DogSprite {
        let dogSprite = DogSprite()
        
        dogSprite.zPosition = 2
        // Image is size 52x34, but make the physics box a little smaller for leniency
        dogSprite.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 42, height: 24))
        dogSprite.physicsBody?.categoryBitMask = DogCategory
        dogSprite.physicsBody?.collisionBitMask = FloorCategory | BrickCategory | BoneCategory
        dogSprite.physicsBody?.contactTestBitMask = BrickCategory | BoneCategory
        dogSprite.physicsBody?.allowsRotation = false
        
        return dogSprite
    }
    
    public func setDogMovingRight(newDogMovingRightValue : Bool) {
        dogMovingRight = newDogMovingRightValue
    }
    
    public func update(deltaTime: TimeInterval) {
        if action(forKey: walkingActionKey) == nil {
            let walkingAction = SKAction.repeatForever(
                SKAction.animate(with: walkFrames, timePerFrame: 0.1, resize: true, restore: true)
            )
            
            run(walkingAction, withKey: walkingActionKey)
        }
        
        if dogMovingRight {
            physicsBody?.velocity.dx = movementSpeed
            xScale = 1
        } else {
            physicsBody?.velocity.dx = -movementSpeed
            xScale = -1
        }
    }
}
