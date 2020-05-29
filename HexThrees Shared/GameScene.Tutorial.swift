//
//  GameScene.Tutorial.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 25.05.20.
//  Copyright © 2020 Ilja Stepanow. All rights reserved.
//

import Foundation
import SpriteKit

extension GameScene {
	public func addCallbacks() {
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(onAddHighlightCircle),
			name: .addSceneHighlight,
			object: nil)
		
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(onResetHighlight),
			name: .resetSceneHighlight,
			object: nil)
		
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(onMoveHighlightCircle),
			name: .moveSceneHighlight,
			object: nil)
		
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(onUpdateDescription),
			name: .updateSceneDescription,
			object: nil)
	}
	
	struct HighlightCircleDto {
		let coord: CGPoint
		let rad: CGFloat
		let delay: Double?
		let name: TutorialNodeNames
	}
	
	@objc func onAddHighlightCircle(notification: Notification) {
		guard let highlightCircleDtos = notification.object as? [HighlightCircleDto] else {
			return
		}
		
		for dto in highlightCircleDtos {
			// @todo: check delay here
			addHighlightCircle(
				where: dto.coord,
				radius: dto.rad,
				name: dto.name.rawValue)
		}
	}
	
	@objc func onMoveHighlightCircle(notification: Notification) {
		guard let dto = notification.object as? HighlightCircleDto else {
			return
		}
		
		moveHighlightCircle(
			to: dto.coord,
			name: dto.name.rawValue)
	}
	
	@objc func onResetHighlight(notification: Notification) {
		removeAllHighlightCircles()
	}
	
	@objc func onUpdateDescription(notification: Notification) {
		guard let dexription = notification.object as? String else {
			return
		}
		
		addDescription(text: dexription)
	}
	
	private func addHighlightCircle(where coord: CGPoint, radius: CGFloat, name: String) {
		let isFirst = greyLayer == nil
		
		createGreyLayer()
		
		let circleShape = SKShapeNode(circleOfRadius: radius)
		circleShape.fillColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
		circleShape.lineWidth = 0.0
		circleShape.position = coord
		circleShape.name = name
		greyLayer?.addChild(circleShape)
		
		let scale: CGFloat = isFirst ? 5.0 : 0.01
		
		circleShape.xScale = scale
		circleShape.yScale = scale
		
		circleShape.run(SKAction.scale(to: 1.0, duration: 1.0).with(mode: .easeOut))
	}
	
	private func moveHighlightCircle(to coord: CGPoint, name: String) {
		greyLayer?
			.childNode(withName: name)?
			.run(SKAction.move(
				to: coord,
				duration: 1.0)
				.with(mode: .easeOut))
	}
	
	private func removeAllHighlightCircles() {
		guard let greyLayer = greyLayer else {
			assert(false, "Grey layer not exist")
		}
		
		for child in greyLayer.children {
			let removeAction = SKAction.perform(#selector(SKNode.removeFromParent), onTarget: child)
			let scaleAction = SKAction.scale(to: 5.0, duration: 1.0).with(mode: .easeOut)
			child.run(SKAction.sequence([scaleAction, removeAction]))
		}
	}
	
	private func createGreyLayer() {
		if greyLayer != nil {
			return
		}
		
		let greyLayer = SKSpriteNode(color: UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0), size: size)
		
		let overlay = SKSpriteNode(color: .black, size: size) // SK bug: if SKSpriteNode is created wo texture, it can not be set afterwards
		overlay.zPosition = zPositions.tutorialHighlight.rawValue
		overlay.shader = SKShader(fileNamed: "tutorialHighlight")
		addChild(overlay)
		
		self.overlay = overlay
		self.greyLayer = greyLayer
		
		addChild(greyLayer)
		greyLayer.position = CGPoint(x: -10000.0, y: 0.0) // Hack: if node is not added to scene, then zooming actions will stall
	}
	
	private func removeGreyLayer() {
		greyLayer?.removeFromParent()
		overlay?.removeFromParent()
		greyLayer = nil
		overlay = nil
	}
	
	public func drawOverlay() {
		guard let overlay = self.overlay,
			let greyLayer = greyLayer else {
			return
		}
		
		overlay.texture = view?.texture(
			from: greyLayer,
			crop: CGRect(
				origin: CGPoint(x: -size.width / 2.0 - 10000.0, y: -size.height / 2.0),
				size: size))
	}
	
	private func addDescription(text: String) {
		let label = prepareLabel() ?? createLabel()
		
		var actions = [
			SKAction.run { label.text = text }, //@todo: how is this possible, do we have memleak here?
			SKAction.fadeIn(withDuration: GameConstants.TutorialTextAppearDuration)]
		
		if label.hasActions() {
			actions.insert(SKAction.wait(forDuration: GameConstants.TutorialTextAppearDuration), at: 0)
		}

		label.run(SKAction.sequence(actions))
	}
	
	private func prepareLabel() -> SKLabelNode? {
		guard let label = childNode(withName: TutorialNodeNames.Description.rawValue) as? SKLabelNode else {
			return nil
		}
		label.run(SKAction.fadeOut(withDuration: GameConstants.TutorialTextAppearDuration))
		return label
	}
	
	private func createLabel() -> SKLabelNode {
		
		let label = SKLabelNode(fontNamed: "Futura Medium")
		label.fontSize = 35
		label.fontColor = SKColor(rgb: 0xECB235)
		label.position.y = -size.height / 3.0
		label.zPosition = zPositions.tutorialDescription.rawValue
		label.name = TutorialNodeNames.Description.rawValue
		addChild(label)
		label.alpha = 0.0
		label.numberOfLines = 2
		return label
	}
	
	private func removeDescription() {
		
	}
}