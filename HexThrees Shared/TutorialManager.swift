//
//  TutorialStep1CMD.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 13.05.20.
//  Copyright © 2020 Ilja Stepanow. All rights reserved.
//

import Foundation

enum TutorialNodeNames: String {
	case Description = "description_label"
	case FirstCell = "first_cell"
	case SecondCell = "second_cell"
}

class TutorialManager {
	enum Steps: Int {
		case HiglightFirstCell
		case MoveFirstCell
		case HighlightSecondCell
		case MoveFirstCellAgain
	}
	
	private(set) var current: Steps?
	
	func inProgress() -> Bool {
		current != nil
	}
	
	func start() {
		current = .HiglightFirstCell
	}
	
	func triggerForStep(model: GameModel, steps: Steps...) -> Bool {
		if steps.contains(where: { $0.rawValue - 1 == current?.rawValue }) {
			next()
			cmdForCurrentStep(model: model)?.run()
			return true
		}
		return false
	}
	
	func finish() {
		UserDefaults.standard.set(true, forKey: SettingsKey.TutorialShown.rawValue)
	}
	
	func cmdForCurrentStep(model: GameModel) -> GameCMD? {
		switch current {
		case .HiglightFirstCell:
			return TutorialStepHighlightFirstCellCmd(model)
		case .MoveFirstCell:
			return TutorialStepMoveFirstCellCmd(model)
		case .HighlightSecondCell:
			return TutorialStepHighlightSecondCellCmd(model)
		case .MoveFirstCellAgain:
			return TutorialStepMoveFirstCellAgainCmd(model)
		default:
			return nil
		}
	}
	
	// @todo: enum it ++!
	func next() {
		switch current {
		case .HiglightFirstCell:
			current = .MoveFirstCell
		case .MoveFirstCell:
			current = .HighlightSecondCell
		case .HighlightSecondCell:
			current = .MoveFirstCellAgain
		default:
			finish()
		}
	}
	
	func alreadyRun() -> Bool {
		false
		// UserDefaults.standard.bool(forKey: SettingsKey.TutorialShown.rawValue)
	}
}
