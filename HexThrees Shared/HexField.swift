//
//  CellsGrid.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 26.08.19.
//  Copyright © 2019 Ilja Stepanow. All rights reserved.
//

import Foundation
import SpriteKit

class HexField {
    
    private var bgHexes = [BgCell]()
    var width: Int //@todo: readonly
    var height: Int //@todo: readonly
    
    init(width: Int, height: Int) {
        self.width = width
        self.height = height
        //@todo: init all at load?
    }
    
    subscript (index: Int) -> BgCell {
        return bgHexes[index]
    }
    
    subscript (x: Int, y: Int) -> BgCell {
        assert(x >= 0 && x < width, "cell coordinate \(x) out of range")
        assert(y >= 0 && y < height, "cell coordinate \(y) out of range")
        let index = y * width + x
        return bgHexes[index]
    }
    
    func getCell(_ x: Int, _ y: Int) -> BgCell {
        
        assert(x >= 0 && x < width, "cell coordinate \(x) out of range")
        assert(y >= 0 && y < height, "cell coordinate \(y) out of range")
        let index = y * width + x
        return bgHexes[index]
    }
    
    func getBgCells(compare: (_: BgCell) -> Bool) -> [BgCell] {
        
        return self.bgHexes.filter(compare)
    }
    
    func hasBgCells(compare: (_: BgCell) -> Bool) -> Bool {
        
        return self.bgHexes.first(where: compare) != nil
    }
    
    func countBgCells(compare: (_: BgCell) -> Bool) -> Int {
        
        return self.bgHexes.filter(compare).count
    }
    
    func executeForAll(lambda: (_:BgCell) -> Void) {
        for i in 0 ..< height * width {
            lambda(self[i])
        }
    }
    
    //@todo: move this to init
    func addToScene(scene: SKScene, geometry: FieldGeometry) {
        for i2 in 0 ..< width {
            for i1 in 0 ..< height {
                let coord = AxialCoord(i2, i1)
                let hexCell = BgCell(
                    hexShape: geometry.createHexCellShape(),
                    blocked: false,
                    coord: coord)
                hexCell.position = geometry.ToScreenCoord(coord)
                bgHexes.append(hexCell)
                scene.addChild(hexCell)
            }
        }
    }
    
    //@todo: move this to deinit
    func clean() {
        bgHexes.removeAll()
    }
    
//    func executeForAll(lambda: (_:BgCell, _: Int, _: Int) -> Void) {
//        for y in 0 ..< height {
//            for x in 0 ..< width {
//                lambda(self[x, y], x, y)
//            }
//        }
//    }
//
//    func executeForAll(lambda: (_:BgCell, _: Int) -> Void) {
//        for i in 0 ..< height * width {
//            lambda(self[i], i)
//        }
//    }
    
    func calculateForSiblings(coord: AxialCoord, calc: inout ICellsStatisticCalculator) {

        calc.clean()

        let xMin = max(coord.c - 1, 0)
        let xMax = min(coord.c + 1, width - 1)
        let yMin = max(coord.r - 1, 0)
        let yMax = min(coord.r + 1, height - 1)


        for x in xMin...xMax  {
            for y in yMin ... yMax {

                // here skipping self cell and corner cells (because of hex geometry)
                if (x == coord.c && y == coord.r) || x == y {
                    continue
                }

                calc.next(cell: self[x, y])
            }
        }
    }
}
