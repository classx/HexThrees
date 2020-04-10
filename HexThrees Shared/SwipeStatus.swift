//
//  File.swift
//  HexThrees
//
//  Created by Ilja Stepanow on 29.05.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation

class SwipeStatus {
	private var inProgress: Bool = false
	private var locked: Bool = false
	
	private(set) var isSomethingChanged: Bool = false
	private(set) var delay: Double = 0.0
	
	func start() {
		inProgress = true
		isSomethingChanged = false
		delay = 0.0
	}
	
	func finish() {
		inProgress = false
		delay = 0.0
	}
	
	func lockSwipes() {
		locked = true
	}
	
	func unlockSwipes() {
		locked = false
	}
	
	func somethingChanged() {
		isSomethingChanged = true
	}
	
	func isInProgressOrLocked() -> Bool {
		return inProgress || locked
	}
	
	func incrementDelay(delay: Double) {
		self.delay = max(delay, self.delay)
	}
}
