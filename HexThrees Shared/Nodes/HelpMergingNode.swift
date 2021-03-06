//
//  TutorialMergingNode.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 26.03.19.
//  Copyright © 2019 Ilja Stepanow. All rights reserved.
//

import Foundation
import SpriteKit

class HelpMergingNode: SKNode {
	var leftNode: GameCell
	var rightNode: GameCell
	let model: GameModel // @todo: weak?
	let valueLeft: Int
	let valueRight: Int
	let xPos: CGFloat
	let updateDelay: Double
	
	init(model: GameModel, width: CGFloat, valueLeft: Int, valueRight: Int) {
		self.leftNode = GameCell(model: model, val: valueLeft)
		self.rightNode = GameCell(model: model, val: valueRight)
		self.model = model
		self.valueLeft = valueLeft
		self.valueRight = valueRight
		self.xPos = width / 4.0
		
		let cellW = CGFloat(model.geometry?.cellWidth ?? 0.0)
		self.updateDelay = GameConstants.HelpVCAnimationDelay * 2.0 * Double(cellW / width)
		
		super.init()
		
		addChild(self.leftNode)
		addChild(self.rightNode)
		
		self.resetPosition()
		
		self.startAgain()
	}
	
	private func resetPosition() {
		self.leftNode.position.x = -self.xPos
		self.rightNode.position.x = self.xPos
	}
	
	@objc private func resetNodes() {
		self.leftNode.updateValue(
			value: self.valueLeft,
			strategy: self.model.strategy)
		self.rightNode.updateValue(
			value: self.valueRight,
			strategy: self.model.strategy)
		self.resetPosition()
	}
	
	@objc private func updateRight() {
		self.rightNode.updateValue(
			value: self.rightNode.value + 1,
			strategy: self.model.strategy,
			direction: .Right)
	}
	
	@objc private func moveAnimation() {
		MoveCellSpriteCMD(self.model).run(
			cell: self.leftNode,
			diff: CGVector(dx: self.xPos * 2, dy: 0),
			duration: GameConstants.HelpVCAnimationDelay)
	}
	
	@objc private func startAgain() {
        
        self.removeAllActions()
		let randomDelay = Double.random / 2
		
		let startDelay = SKAction.wait(forDuration: GameConstants.HelpVCAnimationDelay * (randomDelay + 0.5))
		let animation = SKAction.perform(#selector(HelpMergingNode.moveAnimation), onTarget: self)
		
		let updateRight = SKAction.perform(#selector(HelpMergingNode.updateRight), onTarget: self)
		let resetDelay = SKAction.wait(forDuration: GameConstants.HelpVCAnimationDelay * (1.8 - randomDelay))
		let reset = SKAction.perform(#selector(HelpMergingNode.resetNodes), onTarget: self)
		let startAgain = SKAction.perform(#selector(HelpMergingNode.startAgain), onTarget: self)
		let sequence = SKAction.sequence([reset, startDelay, animation, resetDelay, startAgain])
		
		let updatedelay = SKAction.wait(forDuration: self.updateDelay)
		let updateSequence = SKAction.sequence([startDelay, updatedelay, updateRight])
		
		self.run(sequence)
		self.run(updateSequence)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
