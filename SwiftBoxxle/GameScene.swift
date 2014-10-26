//
//  GameScene.swift
//  SwiftBoxxle
//
//  Created by Kenny Cason on 10/12/14.
//  Copyright (c) 2014 Kenny Cason. All rights reserved.
//
import SpriteKit

// re-used textures
let imageDict: [String : SKSpriteNode] = [
    "moverNorth" : SKSpriteNode(imageNamed: "mover_up.bmp"),
    "moverSouth" : SKSpriteNode(imageNamed: "mover_down.bmp"),
    "moverEast" : SKSpriteNode(imageNamed: "mover_right.bmp"),
    "moverWest" : SKSpriteNode(imageNamed: "mover_left.bmp"),
    "unplacedBox" : SKSpriteNode(imageNamed: "object.bmp"),
    "placedBox" : SKSpriteNode(imageNamed: "object_store.bmp"),
    "wall" : SKSpriteNode(imageNamed: "wall.bmp"),
    "store" : SKSpriteNode(imageNamed: "store.bmp")
]


class GameScene: SKScene {
    
    let dice = Dice()
    let bgMusic = Music(filename: "main.wav", numberOfLoops: -1)
    let finishMusic = Music(filename: "finish.wav")
    let menuMain = SKLabelNode(fontNamed: "Arial")
    let menuReset = SKLabelNode(fontNamed: "Arial")
    let menuNext = SKLabelNode(fontNamed: "Arial")

    var currentLevel: Int = 1
    var level: Level!
    var player: Player!
    var isPaused: Bool = false
    
    override func didMoveToView(view: SKView) {
        loadLevel(currentLevel)
        initLevel()
        initPlayer()
        initMenu()
        
        runAction(SKAction.repeatActionForever(
            SKAction.sequence([
                SKAction.waitForDuration(1.0),
                SKAction.runBlock(checkForWin)
                ])
            ))
        bgMusic.play()
    }
    
    func loadLevel(level: Int) {
        self.level = Level(levelData: LEVEL_DATA[level - 1])
    }
    
    func initPlayer() {
        player = Player(scale: level.scale)
        player.locate(level.start)
        addChild(player.sprite)
    }
    
    func initMenu() {
        menuMain.text = getMenuText()
        menuMain.fontSize = 20
        menuMain.fontColor = SKColor.blackColor()
        menuMain.position = CGPoint(x: size.width - 200, y: size.height - 20)
        menuMain.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left;
        
        menuReset.text = "[reset]"
        menuReset.fontSize = 20
        menuReset.fontColor = SKColor.blackColor()
        menuReset.position = CGPoint(x: size.width - 61, y: size.height - 40)
        menuReset.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left;
                
        menuNext.text = "[next]"
        menuNext.fontSize = 20
        menuNext.fontColor = SKColor.blackColor()
        menuNext.position = CGPoint(x: size.width - 55, y: size.height - 60)
        menuNext.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left;
        
        addChild(menuMain)
        addChild(menuReset)
        addChild(menuNext)
    }
    
    func getMenuText() -> String {
        return "level: " + padNumber(currentLevel, size: 2) + " steps: " + padNumber(player.steps, size: 5)
    }
    
    func padNumber(number:Int, size:Int) -> String {
        let digits = countElements(String(number))
        
        let toPad = size - digits
        var padding = ""
        if toPad > 0 {
            for _ in 1 ... (toPad) {
                padding += "0"
            }
        }
        return padding + String(number)
    }
    
    func initLevel() {
        backgroundColor = SKColor(red: CGFloat(248), green: CGFloat(248), blue: CGFloat(248), alpha: CGFloat(255))
        
        let tileScale = Int(32 * level.scale)

        let height = level.tiles.count - 1
        for y in 0 ... height {
            let width = level.tiles[y].count - 1 // could be variable width inputs
            for x in 0 ... width {
                if(level.tiles[y][x] == 1) {
                    
                    addChild(createSprite("wall", x: x * tileScale + tileScale/2, y: y * tileScale + tileScale/2))
                }
            }
        }

        for goal in level.goals {
            let x = Int(goal.x) * tileScale + tileScale/2
            let y = Int(goal.y) * tileScale + tileScale/2
            addChild(createSprite("store", x: x, y: y))
        }

        for box in level.boxes {
            box.locate(box.position)
            addChild(box.sprite)
        }
    }
    
    func createSprite(resource: String, x: Int, y: Int) -> SKSpriteNode {
        var sprite = SKSpriteNode(texture: imageDict[resource]!.texture)
        sprite.xScale = level.scale
        sprite.yScale = level.scale

        sprite.position = CGPoint(x: x, y: y)
        return sprite
    }
    
    func resetLevel() {
        bgMusic.stop()
        let reveal = SKTransition.flipHorizontalWithDuration(0.5)
        let scene = GameScene(size: size)
        scene.currentLevel = currentLevel
        self.view?.presentScene(scene, transition:reveal)
    }
    
    func loadNextLevel() {
        isPaused = false
        bgMusic.stop()
        let reveal = SKTransition.flipHorizontalWithDuration(0.5)
        let scene = GameScene(size: size)
        scene.currentLevel = currentLevel + 1
        if scene.currentLevel > LEVEL_DATA.count {
            scene.currentLevel = 1
        }
        self.view?.presentScene(scene, transition:reveal)
    }


    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        if isPaused { return }
        
        // Choose one of the touches to work with
        let touch = touches.anyObject() as UITouch
        let touchLocation = touch.locationInNode(self)
        let x = touchLocation.x
        let y = touchLocation.y
        
        if x >= size.width - 60 && y <= size.height - 20 && y >= size.height - 40 {
            resetLevel()
        }
        if x >= size.width - 60 && y <= size.height - 40 && y >= size.height - 60 {
            loadNextLevel()
        }
        
        let dx = sqrt((player.sprite.position.x - x) * (player.sprite.position.x - x))
        let dy = sqrt((player.sprite.position.y - y) * (player.sprite.position.y - y))

        if dy > dx { // moving vertical
            if y > player.sprite.position.y {
                movePlayer(CGPoint(x: 0, y: 1))
            } else if y < player.sprite.position.y {
                movePlayer(CGPoint(x: 0, y: -1))
            }
        }
        if dx > dy { // move horizontal
            if x > player.sprite.position.x {
                movePlayer(CGPoint(x: 1, y: 0))
            } else if x < player.sprite.position.x {
                 movePlayer(CGPoint(x: -1, y: 0))
            }
        }
    }
    
    func movePlayer(delta: CGPoint) {
        let x = Int(player.position.x + delta.x)
        let y = Int(player.position.y + delta.y)
        if level.tiles[y][x] == 0 && pushBoxIfExists(delta) {
            player.move(player.position + delta)
            menuMain.text = getMenuText()
        }
    }
    
    func pushBoxIfExists(delta: CGPoint) -> Bool {
        let newPosition = CGPoint(x: player.position.x + delta.x, y: player.position.y + delta.y)
        
        for box in level.boxes {
            if newPosition == box.position { // box is there
                if canMoveBox(box.position + delta) {
                    box.move(box.position + delta, goals: level.goals)
                    return true
                }
                return false
            }
        }
        return true
    }
    
    func canMoveBox(position: CGPoint) -> Bool {
        if level.tiles[Int(position.y)][Int(position.x)] == 1 { return false }
        for box in level.boxes {
            if(position == box.position) { return false }
        }
        return true
    }

    func doWin() {
        isPaused = true
        bgMusic.stop()
        runAction(
            SKAction.sequence([
                SKAction.runBlock({self.finishMusic.play()}),
                SKAction.waitForDuration(6.0),
                SKAction.runBlock({self.loadNextLevel()})
            ]))

    }

    func checkForWin() {
        for box in level.boxes {
            if ~isBoxOnGoal(box) {
                return
            }
        }
        doWin()
    }
    
    func isBoxOnGoal(box: Box) -> Bool {
        for goal in level.goals {
            if goal == box.position {
                return true
            }
        }
        return false
    }
    
}