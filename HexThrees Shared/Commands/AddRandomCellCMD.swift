//
//  AddRandomCellCMD.swift
//  HexThrees
//
//  Created by Ilja Stepanow on 23.05.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation

class AddRandomCellCMD : GameCMD {
    
    internal var isTutorial : Bool = false
    internal var autoRepeat : Bool = true
    
    private func freeCellWithBonuses(cell: BgCell) -> Bool {
        
        return cell.gameCell == nil &&
            cell.isBlocked == false
    }
    
    private func freeCellWoBonuses(cell: BgCell) -> Bool {
        
        return
            cell.gameCell == nil &&
                cell.isBlocked == false &&
                cell.bonus == nil
    }
    
    override func run() {
        
        var cells = self.gameModel.field.getBgCells(compare: self.freeCellWoBonuses)
        if cells.count == 0 {
            cells = self.gameModel.field.getBgCells(compare: self.freeCellWithBonuses)
        }
        
        guard let bgCell = cells.randomElement() else {
            return
        }
        
        let newElement = GameCell(
            model: self.gameModel,
            val: Float.random < GameConstants.RandomCellIsValue2Probability ? 1 : 0)
        // @todo: overexposition self settings
        newElement.motionBlurDisabled = !self.gameModel.motionBlurEnabled
        if isTutorial {
            newElement.updateColorForTutorial()
        }
        
        bgCell.addGameCell(cell: newElement)
        newElement.playAppearAnimation()
        
        bgCell.bonus?.command.run()
        bgCell.removeBonusWithPickingAnimation(0.0)
        
        if self.gameModel.stressTimer.isEnabled() && autoRepeat{
            StartStressTimerCMD(self.gameModel).run()
        }
    }
}
