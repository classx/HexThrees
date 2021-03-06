//
//  SavedGame.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 06.07.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation

struct SavedGame: Codable {
	struct SavedCell: Codable {
		let exist: Bool
		let val: Int?
		let blocked: Bool
		let bonusType: BonusType?
		let bonusTurns: Int?
	}
	
	struct CollectableBonusCodable: Codable {
		let currentValue: Int
		let maxValue: Int
	}
	
	let cells: [SavedCell]
	let score: Int
	let maxFieldSize: Int
	let bonuses: [BonusType: CollectableBonusCodable]
}
