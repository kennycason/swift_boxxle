//
//  Box.swift
//  SwiftBoxxle
//
//  Created by Kenny Cason on 10/20/14.
//  Copyright (c) 2014 Kenny Cason. All rights reserved.
//

import SpriteKit

class Box {
        
    var sprite : SKSpriteNode
    var position: CGPoint
    var isMoving = false
    var scale: Int
    
    init(position: CGPoint, scale: CGFloat) {
        self.position = position
        self.sprite = SKSpriteNode(texture: imageDict["unplacedBox"]!.texture)
        sprite.xScale = scale
        sprite.yScale = scale
        self.scale = Int(scale * 32)
    }
    
    func locate(newPosition: CGPoint) {
        position = CGPoint(x: newPosition.x, y: newPosition.y)
        let x = Int(newPosition.x) * scale + scale/2
        let y = Int(newPosition.y) * scale + scale/2
        sprite.position = CGPoint(x: x, y: y)
    }
    
    func move(newPosition: CGPoint, goals: [CGPoint]) {
        if isMoving { return }
        
        position = CGPoint(x: newPosition.x, y: newPosition.y)
        
        isMoving = true
        let x = Int(newPosition.x) * scale + scale/2
        let y = Int(newPosition.y) * scale + scale/2
        let spriteNewPosition = CGPoint(x: x, y: y)
        
        let actionMove = SKAction.moveTo(spriteNewPosition, duration: 0.25)
        let actionMoveFinished = SKAction.runBlock({
            self.isMoving = false
            self.afterPush(goals)
        })
        
        sprite.runAction(SKAction.sequence([actionMove, actionMoveFinished]))
    }
    
    func afterPush(goals: [CGPoint]) {
        var isPlaced = false
        for goal in goals {
            if goal.x == position.x && goal.y == position.y {
                isPlaced = true
            }
        }
        if isPlaced {
            self.sprite.texture = imageDict["placedBox"]!.texture
        } else {
            self.sprite.texture = imageDict["unplacedBox"]!.texture
        }
    }
    
}