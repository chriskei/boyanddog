//
//  DogSprite.swift
//  BoyAndDog
//
//  Created by Christopher Kei on 2/20/26.
//

import SpriteKit

public class DogSprite : SKSpriteNode {
    public static func newInstance() -> DogSprite {
        let dogSprite = DogSprite(imageNamed: "dog")
        
        dogSprite.zPosition = 1
        dogSprite.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 40, height: 40))
        dogSprite.physicsBody?.categoryBitMask = DogCategory
        dogSprite.physicsBody?.contactTestBitMask = BoneCategory | BrickCategory
        
        return dogSprite
    }
}
