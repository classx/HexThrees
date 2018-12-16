//
//  SwitchHapticFeedback.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 16.12.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation

class SwitchHapticFeedbackCMD : GameCMD {
    
    func run(isOn: Bool) {
        
        self.gameModel.hapticFeedbackEnabled = isOn
        NotificationCenter.default.post(name: .switchHapticFeedback, object: isOn)
        //@todo: add listeners to this notification, that will actually do somwthing
    }
}
