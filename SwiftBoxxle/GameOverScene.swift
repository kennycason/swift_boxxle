//
//  GameOverScene.swift
//  SwiftBoxxle
//
//  Created by Kenny Cason on 10/25/14.
//  Copyright (c) 2014 Kenny Cason. All rights reserved.
//

import SpriteKit

class GameOverScene: SKScene {
    
    override init(size: CGSize) {
        super.init(size: size)
        
        backgroundColor = SKColor(red: CGFloat(248), green: CGFloat(248), blue: CGFloat(248), alpha: CGFloat(255))
        
        var message = "Congratulations! You beat Boxxle!"
        let label = SKLabelNode(fontNamed: "Arial")
        label.text = message
        label.fontSize = 40
        label.fontColor = SKColor.blackColor()
        label.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(label)
        
        runAction(SKAction.sequence([
            SKAction.waitForDuration(0.1),
            SKAction.runBlock() {
                let reveal = SKTransition.flipHorizontalWithDuration(3.0)
                let scene = GameScene(size: size)
                scene.currentLevel = 1 // reset
                self.view?.presentScene(scene, transition:reveal)
            }
            ]))
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}