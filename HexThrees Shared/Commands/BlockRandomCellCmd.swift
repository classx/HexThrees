//
//  MarkRandomCellAsBlockedCMD.swift
//  HexThrees
//
//  Created by Ilja Stepanow on 20.06.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation

class EmptyCellDistributionCalculator: ICellsStatisticCalculator {
	var openCells: Int = 0
	var gameCells: Int = 0
	
	func next(socket: BgCell?) {
		
		guard let cell = socket else {
			return
		}
		
		if cell.isBlocked {
			return
		}
		
		openCells += 1
		
		if cell.gameCell != nil {
			gameCells += 1
		}
	}
	
	func clean() {
		openCells = 0
		gameCells = 0
	}
	
	func probability() -> Float {
		if openCells == 0 {
			return 0.0
		}
		
		return Float(gameCells) / Float(openCells)
	}
}

class BlockRandomCellCmd: GameCMD {
	override func run() {
		let cells = gameModel.field.getBgCellsWithPriority(
			required: HexField.freeCell,
			priority: HexField.cellWoBonuses, HexField.cellWoShader)
		
		let dice = ProbabilityArray<BgCell>()
		let calc = EmptyCellDistributionCalculator()
		var icalc: ICellsStatisticCalculator = calc
		// for some reason I cannot do &(calc as ICellsStatisticCalculator)
		
		for freeCell in cells {
			gameModel.field.calculateForSiblings(coord: freeCell.coord, calc: &icalc)
			dice.add(freeCell, calc.probability())
		}
		
		guard let randomCell = dice.getRandom() else {
			return
		}
		
		if randomCell.bonus != nil {
			randomCell.removeBonusWithDisposeAnimation()
		}
		
		randomCell.block()
	}
}
