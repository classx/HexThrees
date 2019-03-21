//
//  CreateCellsFromAllPaletteCMD.swift
//  HexThrees
//
//  Created by Ilja Stepanow on 14.06.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation

class DebugPaletteCMD : GameCMD {

    override func run() {
        
        for i in 0 ..< self.gameModel.fieldHeight * self.gameModel.fieldWidth {
                
            let newElement = GameCell(model: self.gameModel, val: 5)
            self.gameModel.bgHexes[i].addGameCell(cell: newElement)
            newElement.playAppearAnimation()
        }
    }
}
