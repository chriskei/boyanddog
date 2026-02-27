//
//  GameViewController.swift
//  BoyAndDog
//
//  Created by Christopher Kei on 2/20/26.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sceneNode = MenuScene(size: view.frame.size)
        
        if let view = self.view as! SKView? {
            view.presentScene(sceneNode)
            view.ignoresSiblingOrder = true
            
            view.showsPhysics = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
