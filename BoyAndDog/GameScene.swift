//
//  GameScene.swift
//  BoyAndDog
//
//  Created by Christopher Kei on 2/20/26.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    private let menuLayer = SKNode()
    private var gameStarted = false
    private var playWithDog = true
    
    private let random = GKARC4RandomSource()
    private var hud = HudNode()
    
    private let walkingActionKey = "action_walking"
    private let brickTexture = SKTexture(imageNamed: "brick")
    private let chocolateTexture = SKTexture(imageNamed: "chocolate")
    private let boneTexture = SKTexture(imageNamed: "bone")
    
    private var lastUpdateTime : TimeInterval = 0
    private var currentSpawnTime : TimeInterval = 0
    private var spawnRate : TimeInterval = 0.5
    private var boy : BoySprite!
    private var dog : DogSprite!
    private var isGameOver = false
    
    override func sceneDidLoad() {
        self.lastUpdateTime = 0
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: -2.0)
        
        let background = SKSpriteNode(imageNamed: "background")
        background.scale(to: CGSize(width: size.width, height: size.height))
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.zPosition = 0
        
        addChild(background)
        
        let floorNode = SKShapeNode(rectOf: CGSize(width: size.width, height: 5))
        floorNode.position = CGPoint(x: size.width / 2, y: 30)
        floorNode.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: -size.width / 2, y: 0), to: CGPoint(x: size.width, y: 0))
        floorNode.physicsBody?.categoryBitMask = FloorCategory
        floorNode.physicsBody?.contactTestBitMask = ChocolateCategory | BoneCategory | BrickCategory
        floorNode.physicsBody?.friction = 0
        
        addChild(floorNode)
        
        spawnBoy()
        spawnDog()
        setupMenu()
    }
    
    func setupMenu() {
        menuLayer.name = "menuLayer"
        menuLayer.zPosition = 2
        addChild(menuLayer)
        
        let boyLabel = SKLabelNode(fontNamed: FontName)
        boyLabel.name = "boyButton"
        boyLabel.text = "BOY"
        boyLabel.horizontalAlignmentMode = .left
        boyLabel.fontSize = 40
        
        let boyAndDogLabel = SKLabelNode(fontNamed: FontName)
        boyAndDogLabel.name = "boyAndDogButton"
        boyAndDogLabel.text = "BOY AND DOG"
        boyAndDogLabel.horizontalAlignmentMode = .left
        boyAndDogLabel.fontSize = 40
        
        // Determine widest label
        let maxWidth = max(boyLabel.frame.width, boyAndDogLabel.frame.width)

        // Position so the CENTER of the widest element sits at frame.midX
        let leftX = frame.midX - maxWidth / 2

        boyLabel.position = CGPoint(x: leftX, y: frame.midY + 50)
        boyAndDogLabel.position = CGPoint(x: leftX, y: frame.midY)

        menuLayer.addChild(boyLabel)
        menuLayer.addChild(boyAndDogLabel)
    }
    
    func startGame() {
        if gameStarted { return }

        isGameOver = false
        gameStarted = true
        physicsWorld.speed = 1

        currentSpawnTime = 0
        lastUpdateTime = 0

        let fade = SKAction.fadeOut(withDuration: 0.4)

        menuLayer.run(fade) {
            self.safelyRemove(node: self.menuLayer)
        }

        if let overlay = childNode(withName: "gameOverOverlay") {
            overlay.run(fade) {
                self.safelyRemove(node: overlay)
            }
        }

        clearGameObjects()

        spawnBoy()
        
        if playWithDog {
            spawnDog()
        } else {
            safelyRemove(node: dog)
        }

        let newHud = HudNode()
        newHud.setup(size: size)
        addChild(newHud)
        hud = newHud
    }
    
    func clearGameObjects() {
        for node in children {
            if let body = node.physicsBody {
                let category = body.categoryBitMask
                
                if category == BrickCategory ||
                   category == ChocolateCategory ||
                   category == BoneCategory {
                    safelyRemove(node: node)
                }
            }
        }
    }
    
    func spawnBoy() {
        if let currentBoy = boy, children.contains(currentBoy) {
            safelyRemove(node: currentBoy)
        }
        
        boy = BoySprite.newInstance()
        boy.position = CGPoint(x: -100, y: 60)
        
        addChild(boy)
    }
    
    func spawnDog() {
        if let currentDog = dog, children.contains(currentDog) {
            safelyRemove(node: currentDog)
        }
        
        dog = DogSprite.newInstance()
        dog.position = CGPoint(x: -100, y: 60)
        
        addChild(dog)
    }
    
    func spawnBrick() {
        let brick = SKSpriteNode(texture: brickTexture)
         
        brick.zPosition = 1
        brick.physicsBody = SKPhysicsBody(texture: brickTexture, size: brick.size)
        brick.physicsBody?.categoryBitMask = BrickCategory
        brick.physicsBody?.contactTestBitMask = FloorCategory | BoyCategory | DogCategory
        
        let randomPosition = abs(CGFloat(random.nextInt()).truncatingRemainder(dividingBy: size.width))
        brick.position = CGPoint(x: randomPosition, y: size.height + 50)
        
        addChild(brick)
    }
    
    func spawnChocolate() {
        let chocolate = SKSpriteNode(texture: chocolateTexture)
        
        chocolate.zPosition = 1
        chocolate.physicsBody = SKPhysicsBody(texture: chocolateTexture, size: chocolate.size)
        chocolate.physicsBody?.categoryBitMask = ChocolateCategory
        chocolate.physicsBody?.contactTestBitMask = FloorCategory | BoyCategory
        
        let randomPosition = abs(CGFloat(random.nextInt()).truncatingRemainder(dividingBy: size.width))
        chocolate.position = CGPoint(x: randomPosition, y: size.height + 50)
        
        addChild(chocolate)
    }
    
    func spawnBone() {
        let bone = SKSpriteNode(texture: boneTexture)
        
        bone.zPosition = 1
        bone.physicsBody = SKPhysicsBody(texture: boneTexture, size: bone.size)
        bone.physicsBody?.categoryBitMask = BoneCategory
        bone.physicsBody?.contactTestBitMask = FloorCategory | DogCategory
        
        let randomPosition = abs(CGFloat(random.nextInt()).truncatingRemainder(dividingBy: size.width))
        bone.position = CGPoint(x: randomPosition, y: size.height + 50)
        
        addChild(bone)
    }
    
    func gameOver() {
        guard !isGameOver else { return }
        
        gameStarted = false
        isGameOver = true
        physicsWorld.speed = 0
        
        safelyRemove(node: hud)

        let overlay = SKNode()
        overlay.name = "gameOverOverlay"
        overlay.zPosition = 2
        addChild(overlay)
        
        let dim = SKShapeNode(rectOf: size)
        dim.fillColor = .black
        dim.alpha = 0.6
        dim.position = CGPoint(x: size.width / 2, y: size.height / 2)
        overlay.addChild(dim)
        
        let scoreLabel = SKLabelNode(fontNamed: FontName)
        scoreLabel.text = "Score: \(hud.score)"
        scoreLabel.fontSize = 42
        scoreLabel.horizontalAlignmentMode = .left
        
        let boyLabel = SKLabelNode(fontNamed: FontName)
        boyLabel.name = "boyButton"
        boyLabel.text = "BOY"
        boyLabel.fontSize = 40
        boyLabel.horizontalAlignmentMode = .left
        
        let boyAndDogLabel = SKLabelNode(fontNamed: FontName)
        boyAndDogLabel.name = "boyAndDogButton"
        boyAndDogLabel.text = "BOY AND DOG"
        boyAndDogLabel.fontSize = 40
        boyAndDogLabel.horizontalAlignmentMode = .left
        
        // Determine widest label
        let maxWidth = max(scoreLabel.frame.width, boyLabel.frame.width, boyAndDogLabel.frame.width)

        // Position so the CENTER of the widest element sits at frame.midX
        let leftX = frame.midX - maxWidth / 2
        
        scoreLabel.position = CGPoint(x: leftX, y: frame.midY + 50)
        boyLabel.position = CGPoint(x: leftX, y: frame.midY)
        boyAndDogLabel.position = CGPoint(x: leftX, y: frame.midY - 50)
        
        overlay.addChild(scoreLabel)
        overlay.addChild(boyLabel)
        overlay.addChild(boyAndDogLabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        // Check menu buttons
        let nodes = nodes(at: location)
        for node in nodes {
            if node.name == "boyButton" {
                playWithDog = false
                startGame()
            } else if node.name == "boyAndDogButton" {
                playWithDog = true
                startGame()
            }
        }
        
        // Boy and dog movement
        if playWithDog {
            if location.y > size.height / 2 {
                if location.x < size.width / 2 {
                    boy.setBoyMovingRight(newBoyMovingRightValue: false)
                } else {
                    boy.setBoyMovingRight(newBoyMovingRightValue: true)
                }
            } else {
                if location.x < size.width / 2 {
                    dog.setDogMovingRight(newDogMovingRightValue: false)
                } else {
                    dog.setDogMovingRight(newDogMovingRightValue: true)
                }
            }
        } else {
            if location.x < size.width / 2 {
                boy.setBoyMovingRight(newBoyMovingRightValue: false)
            } else {
                boy.setBoyMovingRight(newBoyMovingRightValue: true)
            }
        }
        
        let node = atPoint(location)
        
        if node.name == "replay" {
            let newGame = GameScene(size: size)
            newGame.scaleMode = scaleMode
            
            view?.presentScene(newGame, transition: SKTransition.reveal(with: .down, duration: 0.75))
        }
        
        if node.name == "menu" {
            let menu = MenuScene(size: size)
            menu.scaleMode = scaleMode
            
            view?.presentScene(menu, transition: SKTransition.reveal(with: .down, duration: 0.75))
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func update(_ currentTime: TimeInterval) {
        if !isGameOver {
            if (self.lastUpdateTime == 0) {
                self.lastUpdateTime = currentTime
            }
            
            let dt = currentTime - self.lastUpdateTime
            self.lastUpdateTime = currentTime
            
            currentSpawnTime += dt
            
            if currentSpawnTime > spawnRate {
                currentSpawnTime = 0
                
                if gameStarted {
                    let randomNumber = Double.random(in: 0...1)
                    
                    if playWithDog {
                        randomNumber < 0.80 ? spawnBrick() : randomNumber < 0.90 ? spawnChocolate() : spawnBone()
                    } else {
                        randomNumber < 0.90 ? spawnBrick() : spawnChocolate()
                    }
                }
            }
        
            boy.update(deltaTime: dt)
            dog.update(deltaTime: dt)
            
            if boy.position.x > size.width + 22 {
                boy.position.x = 0
            } else if boy.position.x < -22 {
                boy.position.x = size.width
            }
            
            if dog.position.x > size.width + 21 {
                if playWithDog {
                    dog.position.x = 0
                } else {
                    safelyRemove(node: dog)
                }
            } else if dog.position.x < -21 {
                if playWithDog {
                    dog.position.x = size.width
                } else {
                    safelyRemove(node: dog)
                }
            }
            
            hud.addPoint(points: dt)
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        
        let collision = bodyA.categoryBitMask | bodyB.categoryBitMask
        
        // MARK: - Floor hits falling objects (remove them)
        if collision == FloorCategory | BrickCategory ||
           collision == FloorCategory | ChocolateCategory ||
           collision == FloorCategory | BoneCategory {
            
            let fallingBody = (bodyA.categoryBitMask == FloorCategory) ? bodyB : bodyA
            safelyRemove(node: fallingBody.node)
        }
        
        // MARK: - Boy or Dog hits Brick → Game Over
        if collision == BoyCategory | BrickCategory ||
           collision == DogCategory | BrickCategory {
            
            gameOver()
        }
        
        // MARK: - Boy collects Chocolate
        if collision == BoyCategory | ChocolateCategory {
            
            let chocolateBody = (bodyA.categoryBitMask == ChocolateCategory) ? bodyA : bodyB
            
            if safelyRemove(node: chocolateBody.node) {
                hud.addPoint(points: 10)
            }
        }
        
        // MARK: - Dog collects Bone
        if collision == DogCategory | BoneCategory {
            
            let boneBody = (bodyA.categoryBitMask == BoneCategory) ? bodyA : bodyB
            
            if safelyRemove(node: boneBody.node) {
                hud.addPoint(points: 10)
            }
        }
    }
    
    @discardableResult
    func safelyRemove(node: SKNode?) -> Bool {
        guard let node = node else { return false }
        
        // If already removed, don't process again
        guard node.parent != nil else { return false }
        
        node.physicsBody = nil
        node.removeAllActions()
        node.removeFromParent()
        
        return true
    }
}
