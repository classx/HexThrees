//
//  GameModel.swift
//  HexThrees
//
//  Created by Ilja Stepanow on 23.05.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation
import SpriteKit

class GameModel {
    
    var fieldWidth: Int
    var fieldHeight: Int
    var strategy: MergingStrategy
    var geometry: FieldGeometry
    
    // Some common properties
    var bgHexes : [BgCell] = [BgCell]()
    var swipeStatus = SwipeStatus()
    var score : Int = 0
    var newUnblockCellScore : Int = 20 //@todo: make proper calculation related to field size and strategy
    
    func getBgCells(compare: (_: BgCell) -> Bool) -> [BgCell] {
        
        return self.bgHexes.filter(compare)
    }
    
    func hasBgCells(compare: (_: BgCell) -> Bool) -> Bool {
        
        return self.bgHexes.first(where: compare) == nil
    }
    
    init(screenWidth: CGFloat, fieldSize: Int, strategy: MergingStrategy) {
        
        self.geometry = FieldGeometry(
            screenWidth: screenWidth,
            fieldSize: fieldSize)
        self.strategy = strategy
        self.fieldWidth = fieldSize
        self.fieldHeight = fieldSize
    }
    
    func reset(screenWidth: CGFloat, fieldSize: Int, strategy: MergingStrategy) {
        
        self.geometry = FieldGeometry(
            screenWidth: screenWidth,
            fieldSize: fieldSize)
        self.strategy = strategy
        self.fieldWidth = fieldSize
        self.fieldHeight = fieldSize
    }
}
