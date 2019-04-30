//
//  SwipeGestureNode.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 24.04.19.
//  Copyright © 2019 Ilja Stepanow. All rights reserved.
//

import Foundation
import SpriteKit

class SwipeGestureNode : SKNode {
    
    var shape: SKShapeNode
    let node1: SKNode
    let node2: SKNode
    let point1: CGPoint
    let point2: CGPoint
    
    init(from: CGPoint, to: CGPoint) {
        
        self.point1 = from
        self.point2 = to
        
        let path = CGMutablePath()
        shape = SKShapeNode(path: path)
        shape.strokeColor = .red
        
        //@todo: try to use this
        //shape.lineJoin
        //shape.lineJoin
        shape.lineWidth = 2 //@todo: what is length then?
        
        self.node1 = SKNode()
        self.node2 = SKNode()
        
        super.init()
        
        addChild(node1)
        addChild(node2)
        addChild(shape)
    }
    
    func playOnce(startDelay: TimeInterval, duration: TimeInterval) {
        let startDelayAction = SKAction.wait(forDuration: startDelay)
        let animationAction = SKAction.run( { self.startAnimation(duration: duration) } )
        self.run(SKAction.sequence([startDelayAction, animationAction, pauseAction])
    }
    
    func repeatIndefinitely(startDelay: TimeInterval, duration: TimeInterval, pause: TimeInterval) {
        
        let startDelayAction = SKAction.wait(forDuration: startDelay)
        let animationAction = SKAction.run( { self.startAnimation(duration: duration) } )
        let pauseAction = SKAction.wait(forDuration: duration + pause)
        
        let sequence = SKAction.sequence([startDelayAction, animationAction, pauseAction])
        self.run(SKAction.repeatForever(sequence))
    }
    
    @objc private func startAnimation(duration: TimeInterval) {
        
        let move1 = SKAction.move(to: point2, duration: duration)
        move1.timingMode = .easeIn
        node1.removeAllActions()
        node1.position = point1
        node1.run(move1)
        
        let move2 = SKAction.move(to: point2, duration: duration)
        move2.timingMode = .easeOut
        node2.removeAllActions()
        node2.position = point1
        node2.run(move2)
    }
    
    func update() {
        
        let path = CGMutablePath()
        path.move(to: node1.position)
        path.addLine(to: node2.position)
        
        shape.path = path
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
