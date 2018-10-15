//
//  UnlockRandomCellCMD.swift
//  HexThrees
//
//  Created by Ilja Stepanow on 20.06.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation

class UnlockRandomCellCMD : GameCMD {
    
    override func run() {
        
        var blockedCells = [BgCell]()
        for i in self.gameModel.bgHexes {
            if(i.isBlocked) {
                blockedCells.append(i)
            }
        }
        
        blockedCells.randomElement()?.unblock()
    }
    
}
