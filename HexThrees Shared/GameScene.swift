//
//  GameScene.swift
//  HexThrees Shared
//
//  Created by Ilja Stepanow on 10.04.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var hexCalculator : HexCalculator?
    var mergingStrategy : MergingStrategy = FibonacciMergingStrategy()
    var bgHexes : [BgCell] = [BgCell]()
    let fieldWidth: Int = 5
    let fieldHeight: Int = 5 //@todo: test & fix with different values!
    let startOffsetX: Int = -2
    let startOffsetY: Int = -2
    
    class func newGameScene() -> GameScene {
        // Load 'GameScene.sks' as an SKScene.
        guard let scene = SKScene(fileNamed: "GameScene") as? GameScene else {
            print("Failed to load GameScene.sks")
            abort()
        }
        
        // Set the scale mode to scale to fit the window
        scene.scaleMode = .aspectFill
        
        return scene
    }
    
    func setUpScene() {
        
        let emptyHexSprite = SKSpriteNode.init(imageNamed: "hex")
        
        hexCalculator = HexCalculator(
            width : fieldWidth,
            height : fieldHeight,
            gap: 5.0,
            cellSize: emptyHexSprite.size)
        
        var i = 0
        for i1 in startOffsetX ..< startOffsetX + fieldWidth {
            for i2 in startOffsetY ..< startOffsetY + fieldHeight {
                let hexCell = BgCell(
                    coord: AxialCoord(i1, i2),
                    hexCalc : hexCalculator!)
                self.addChild(hexCell)
                self.bgHexes.append(hexCell)
                i += 1
            }
        }
        
        //addRandomElement()
        //addRandomElement()
        //addRandomElement()
        //addRandomElement()
        
        let firstElement = GameCell(val: 1)
        self.bgHexes[0].addGameCell(cell: firstElement)
        
        let secondElement = GameCell(val: 1)
        self.bgHexes[1].addGameCell(cell: secondElement)
        
        let secondElement2 = GameCell(val: 1)
        self.bgHexes[2].addGameCell(cell: secondElement2)
        
        let secondElement3 = GameCell(val: 1)
        self.bgHexes[3].addGameCell(cell: secondElement3)
        
        let secondElement4 = GameCell(val: 1)
        self.bgHexes[4].addGameCell(cell: secondElement4)
    }
    
    private func addRandomElement() {
        
        var freeCells = Array<BgCell>()
        for i in self.bgHexes {
            if(i.gameCell == nil) {
                freeCells.append(i)
            }
        }
        
        let random = Int(arc4random()) % freeCells.count
        
        let newElement = GameCell(val: 1)
        freeCells[random].addGameCell(cell: newElement)
        newElement.playAppearAnimation()
    }
    
    //@todo: make cmd from it
    private func moveXUp() {
        
        for i2 in 0 ..< fieldHeight {
            var line = Array<BgCell>()
            for i1 in 0 ..< fieldWidth {
                //it should be i1 in fieldWidth ..< 0 but swift sucks
                line.append(self.bgHexes[(i2 + 1) * fieldWidth - i1 - 1])
            }
            moveLine(cells: line)
        }
    }
    
    //@todo: make cmd from it
    private func moveXDown() {
        
        for i2 in 0 ..< fieldHeight {
            var line = Array<BgCell>()
            for i1 in 0 ..< fieldWidth {
                line.append(self.bgHexes[i2 * fieldWidth + i1])
            }
            moveLine(cells: line)
        }
    }
    
    private func moveYUp() {
       
        for i1 in 0 ..< fieldWidth {
            var line = Array<BgCell>()
            for i2 in 0 ..< fieldHeight {
                //it should be i1 in fieldWidth ..< 0 but swift sucks
                line.append(self.bgHexes[(fieldHeight - i2 - 1) * fieldWidth + i1])
            }
            moveLine(cells: line)
        }
    }
    
    //@todo: make cmd from it
    private func moveYDown() {
        
        for i1 in 0 ..< fieldWidth {
            var line = Array<BgCell>()
            for i2 in 0 ..< fieldHeight {
                line.append(self.bgHexes[i2 * fieldWidth + i1])
            }
            moveLine(cells: line)
        }
    }
    
    
    /*
     //This code movin one by one:
     let hexCell = self.bgHexes[i2 * fieldWidth + i1]
     guard let gameCell = hexCell.gameCell else {
     continue
     }
     
     if(i1 == fieldWidth - 1) {
     hexCell.removeGameCell()
     continue
     }
     
     let newCellRoot = self.bgHexes[i2 * fieldWidth + i1 + 1]
     let coordDiff = CGVector(
     dx:  newCellRoot.position.x - hexCell.position.x,
     dy:  newCellRoot.position.y - hexCell.position.y)
     
     gameCell.newParent = newCellRoot
     
     let moveAction = SKAction.move(by: coordDiff, duration: 1.0)
     let resetAction = SKAction.perform(#selector(GameCell.resetCoordinates), onTarget: gameCell)
     let addToNewRootAction = SKAction.perform(#selector(GameCell.switchToNewParent), onTarget: gameCell)
     gameCell.run(SKAction.sequence([moveAction, resetAction, addToNewRootAction]))*/
    
    //@todo: make separate class or cmd from this
    private func moveLine(cells: Array<BgCell>) {
        
        let count = cells.count
        
        func switchCellParent(from: BgCell, to: BgCell) {
            //@todo: after this do we need BGCell functions remove/add?
            from.gameCell?.removeFromParent()
            to.addGameCell(cell: from.gameCell!)
            from.gameCell = nil
        }
        
        func moveCell(from: Int, to: Int, newVal: Int?) {
            
            if from == to {
                return
            }
            
            //@todo: throw if from >= count
            //@todo: throw if to >= count
            //@todo: throw if from >= to
            //@todo: throw if _from_ cell have gamecell (what if merging?)
            //@todo: throw if _to_ cell doesnt have gamecell
            
            let fromCell = cells[from]
            let toCell = cells[to]
            
            switchCellParent(from: fromCell, to: toCell)
            
            //@todo: add extensions to CGVector.init(points diff)
            let diff = CGVector(
                dx: toCell.position.x - fromCell.position.x,
                dy: toCell.position.y - fromCell.position.y)
            
            toCell.gameCell?.position.x -= diff.dx
            toCell.gameCell?.position.y -= diff.dy
            
            let moveAction = SKAction.move(by: diff, duration: Double(from - to) * 0.2) //@todo: duration should depend from distance
            toCell.gameCell?.run(moveAction)
            
            if newVal != nil {
                //@todo: run some animation?
                toCell.gameCell?.updateValue(newVal!)
            }
        }
        
        func deleteCell(index: Int) {
            cells[index].removeGameCell()
        }
        
        func findNextNonEmpty(startIndex: Int) -> Int? {
            
            var i = startIndex
            
            while i < count {
                if cells[i].gameCell != nil {
                    return i
                }
                i += 1
            }
            
            return nil
        }
        
        func processCell(counter: Int) {
            
            // end of algorithm
            if counter >= count {
                return
            }
            
            guard let first : Int = findNextNonEmpty(startIndex: counter) else {
                return
            }
            
            guard let second : Int = findNextNonEmpty(startIndex: first + 1) else {
                moveCell(from: first, to: counter, newVal: nil) //@todo: make newVal a optional parameter
                return
            }
            
            let firstVal = cells[first].gameCell!.value
            let secondVal = cells[second].gameCell!.value
            
            if let newVal = mergingStrategy.isSiblings(firstVal, secondVal) {
                deleteCell(index: first)
                moveCell(from: second, to: counter, newVal: newVal)
                processCell(counter: counter + 1)
            }
            else {
                moveCell(from: first, to: counter, newVal: nil)
                moveCell(from: second, to: counter + 1, newVal: nil)
                processCell(counter: counter + 1)
            }
        }
        
        //run recursive algorithm, starting with 0
        processCell(counter: 0)
    }
    
    #if os(watchOS)
    override func sceneDidLoad() {
        self.setUpScene()
    }
    #else
    override func didMove(to view: SKView) {
        self.setUpScene()
    }
    #endif

    /*func makeSpinny(at pos: CGPoint, color: SKColor) {
        if let spinny = self.spinnyNode?.copy() as! SKShapeNode? {
            spinny.position = pos
            spinny.strokeColor = color
            self.addChild(spinny)
        }
    }*/
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}

#if os(iOS) || os(tvOS)
// Touch-based event handling
extension GameScene {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /*if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        
        for t in touches {
            self.makeSpinny(at: t.location(in: self), color: SKColor.green)
        }*/
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        /*for t in touches {
            self.makeSpinny(at: t.location(in: self), color: SKColor.blue)
        }*/
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        /*for t in touches {
            self.makeSpinny(at: t.location(in: self), color: SKColor.red)
        }*/
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        /*for t in touches {
            self.makeSpinny(at: t.location(in: self), color: SKColor.red)
        }*/
    }
    
   
}
#endif

#if os(OSX)
// Mouse-based event handling
extension GameScene {

    override func mouseDown(with event: NSEvent) {
        /*if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        self.makeSpinny(at: event.location(in: self), color: SKColor.green)*/
        //self.moveXUp()
        let coord = event.location(in: self)
        if coord.x < 0 && coord.y < 0 {
            self.moveXDown()
        }
        else if coord.x < 0 && coord.y > 0 {
            self.moveYUp()
        }
        else if coord.x > 0 && coord.y < 0 {
            self.moveYDown()
        }
        else if coord.x > 0 && coord.y > 0 {
            self.moveXUp()
        }
        addRandomElement()
    }
    
    override func mouseDragged(with event: NSEvent) {
        //self.makeSpinny(at: event.location(in: self), color: SKColor.blue)
    }
    
    override func mouseUp(with event: NSEvent) {
        //self.makeSpinny(at: event.location(in: self), color: SKColor.red)
    }

}
#endif

