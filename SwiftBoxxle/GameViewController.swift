//
//  GameViewController.swift
//  SwiftBoxxle
//
//  Created by Kenny Cason on 10/12/14.
//  Copyright (c) 2014 Kenny Cason. All rights reserved.
//
import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let scene = GameScene(size: view.bounds.size)
        let skView = view as SKView
        skView.showsFPS = false
        skView.showsNodeCount = false
        skView.ignoresSiblingOrder = true
        scene.scaleMode = SKSceneScaleMode.ResizeFill
        skView.presentScene(scene)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}