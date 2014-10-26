//
//  Level.swift
//  SwiftBoxxle
//
//  Created by Kenny Cason on 10/14/14.
//  Copyright (c) 2014 Kenny Cason. All rights reserved.
//

import SpriteKit

struct Tiles {
    static let Empty = 0
    static let Brick = 1
}

class Level {
    
    var start: CGPoint
    var tiles: [[Int]]
    var boxes: [Box] = []
    var goals: [CGPoint] = []
    var scale: CGFloat
    
    init(levelData: LevelData) {
        self.tiles = levelData.tiles
        for box in levelData.boxes {
            self.boxes.append(Box(position: CGPoint(x: box[0], y: box[1]), scale: levelData.scale))
        }
        for goal in levelData.goals {
            self.goals.append(CGPoint(x: goal[0], y: goal[1]))
        }
        self.start = CGPoint(x: levelData.start[0], y: levelData.start[1])
        self.scale = levelData.scale
    }
    
}