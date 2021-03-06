//
//  Playback.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 07.08.19.
//  Copyright © 2019 Ilja Stepanow. All rights reserved.
//

import Foundation

protocol IPlayback {
	func setRange(from: Double, to: Double)
	func setRange(from: Float, to: Float)
	func start(duration: TimeInterval, reversed: Bool?, repeated: Bool?, onFinish: (() -> Void)?)
	func rollback(duration: TimeInterval, onFinish: (() -> Void)?)
	func update(delta: TimeInterval) -> Double
	func reverse(reversed: Bool?)
	// func pause() //@todo
	// func resume() //@todo
}

extension IPlayback {
	func start(duration: TimeInterval, reversed: Bool? = false, repeated: Bool? = false, onFinish: (() -> Void)? = nil) {
		self.start(duration: duration, reversed: reversed, repeated: repeated, onFinish: onFinish)
	}
}

class Playback: IPlayback {
	private var started = TimeInterval()
	private var duration = TimeInterval()
	private var reversed = false
	private var repeated = false
	private var paused = false
	private var scale: Double = 1.0
	private var start: Double = 0.0
	private var finishCallback: (() -> Void)?
	
	init() {
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(self.setPauseFlag),
			name: .pauseTimers,
			object: nil)
	}
	
	convenience init(from: Double = 0.0,
					 to: Double = 1.0,
					 duration: TimeInterval,
					 reversed: Bool? = nil,
					 repeated: Bool? = false,
					 onFinish: (() -> Void)? = nil) {
		self.init()
		self.setRange(
			from: from,
			to: to)
		self.start(
			duration: duration,
			reversed: reversed,
			repeated: repeated,
			onFinish: onFinish)
	}
	
	func setRange(from: Double, to: Double) {
		self.scale = (to - from)
		self.start = from
	}
	
	func setRange(from: Float, to: Float) {
		self.setRange(from: Double(from), to: Double(from))
	}
	
	func start(duration: TimeInterval, reversed: Bool? = nil, repeated: Bool? = false, onFinish: (() -> Void)? = nil) {
		self.repeated = repeated ?? false
		self.started = TimeInterval()
		self.duration = duration
		self.reversed = reversed ?? self.reversed
		self.finishCallback = onFinish
	}
	
	// @todo: test this
	func rollback(duration: TimeInterval, onFinish: (() -> Void)? = nil) {
		let percent = self.normalize(
			value: self.started,
			duration: self.duration)
		let newPercent = 1.0 - percent
		self.reverse()
		self.finishCallback = onFinish
		
		self.started = Double(newPercent) * duration
		self.duration = duration
	}
	
	func update(delta: TimeInterval) -> Double {
		// If playback was paused, it starts again automatically
		if self.paused {
			self.paused = false
		} else {
			self.started += delta
		}
		
		// @todo: testcase: what if update delta is more than one duration?
		if self.started >= self.duration {
			self.finishCallback?()
			if self.repeated {
				self.started -= self.duration
			} else {
				// @note: may be there is better way to stop update other than this
				self.finishCallback = nil
			}
		}
		
		var percent = self.normalize(
			value: self.started,
			duration: self.duration)
		
		if self.reversed {
			percent = 1.0 - percent
		}
		
		return self.scale(value: percent)
	}
	
	func reverse(reversed: Bool? = nil) {
		self.reversed = reversed ?? !self.reversed
	}
	
	@objc private func setPauseFlag() {
		self.paused = true
	}
	
	private func scale(value: Double) -> Double {
		return self.start + value * self.scale
	}
	
	private func normalize(value: TimeInterval, duration: TimeInterval) -> Double {
		return Double(min(value / duration, 1.0))
	}
}
