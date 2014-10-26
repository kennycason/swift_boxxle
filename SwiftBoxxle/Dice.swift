//
//  Dice.swift
//  SwiftBoxxle
//
//  Created by Kenny Cason on 10/12/14.
//  Copyright (c) 2014 Kenny Cason. All rights reserved.
//
import SpriteKit

class Dice {
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(#min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    init() { }
    
}
