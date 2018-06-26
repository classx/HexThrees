//
//  MoveXDownCMD.swift
//  HexThrees
//
//  Created by Ilja Stepanow on 23.05.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation

class MoveXDownCMD : GameCMD {
    
    override func run() {
        
        let line = LineCellsContainer(self.gameModel)
        for i2 in 0 ..< self.gameModel.fieldHeight {
            
            for i1 in 0 ..< self.gameModel.fieldWidth {
                let index = i2 * self.gameModel.fieldWidth + i1
                line.add(index)
            }
            
            line.flush()
        }
    }
}
