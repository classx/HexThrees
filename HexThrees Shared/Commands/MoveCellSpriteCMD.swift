//
//  MoveCellSpriteCMD.swift
//  HexThrees
//
//  Created by Ilja Stepanow on 28.05.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation

class MoveCellSpriteCMD : GameCMD {
    
    func run(cell: GameCell, diff: CGVector, duration: Double){
        
        cell.playMoveAnimation(
            diff: diff,
            duration: duration)
    }
}
