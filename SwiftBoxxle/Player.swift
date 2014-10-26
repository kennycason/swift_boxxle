//
//  Player.swift
//  SwiftBoxxle
//
//  Created by Kenny Cason on 10/20/14.
//  Copyright (c) 2014 Kenny Cason. All rights reserved.
//

import SpriteKit

class Player {
    
    var sprite : SKSpriteNode
    var position: CGPoint
    var isMoving = false
    var steps = 1
    var scale: Int!
    
    init(scale: CGFloat) {
        sprite = SKSpriteNode(texture: imageDict["moverEast"]!.texture)
        position = CGPoint(x: 0,y: 0)
        self.scale = Int(scale * 32)
        sprite.xScale = scale
        sprite.yScale = scale
    }
    
    func locate(newPosition: CGPoint) {
        position = CGPoint(x: newPosition.x, y: newPosition.y)
        let x = Int(newPosition.x) * scale + scale/2
        let y = Int(newPosition.y) * scale + scale/2
        sprite.position = CGPoint(x: x, y: y)
    }
    
    func move(newPosition: CGPoint) {
        if isMoving { return }
        steps++;
        
        if newPosition.x < position.x {
            sprite.texture = imageDict["moverWest"]!.texture
        }
        else if newPosition.x > position.x {
            sprite.texture = imageDict["moverEast"]!.texture
        }
        else if newPosition.y < position.y {
            sprite.texture = imageDict["moverSouth"]!.texture
        }
        else if newPosition.y > position.y {
            sprite.texture = imageDict["moverNorth"]!.texture
        }
        
        position = CGPoint(x: newPosition.x, y: newPosition.y)
        
        isMoving = true
        let x = Int(newPosition.x) * scale + scale/2
        let y = Int(newPosition.y) * scale + scale/2
        let spriteNewPosition = CGPoint(x: x, y: y)

        let actionMove = SKAction.moveTo(spriteNewPosition, duration: 0.25)
        let actionMoveFinished = SKAction.runBlock({self.isMoving = false})
        
        sprite.runAction(SKAction.sequence([actionMove, actionMoveFinished]))
    }
    
}