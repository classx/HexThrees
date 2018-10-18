//
//  PaletteManager.swift
//  HexThrees
//
//  Created by Ilja Stepanow on 07.06.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation
import SpriteKit

protocol IPaletteManager {
    
    //var type: ColorSchemaType { get }
    func cellBgColor() -> SKColor
    func sceneBgColor() -> SKColor
    func cellBlockedBgColor() -> SKColor
    func color(value: Int) -> SKColor
    func switchPalette(to: ColorSchemaType)
    
    //@todo: add cells stroke color, font color
    
}

class PaletteManager : IPaletteManager {
    
    private var currentPalette : ColorSchema
    private let allPalettes : Dictionary<ColorSchemaType, ColorSchema>
    
    init() {
        
        let gray = ColorSchema(
            bgColor: .yellow,
            sceneBgColor: .gray,
            cellBgColor: .brown,
            cellBlockedBgColor: .cyan,
            colors: [0: SKColor(rgb: 0x07BEB8),
                      1: SKColor(rgb: 0x0568AE),
                      2: SKColor(rgb: 0xE9E228),
                      3: SKColor(rgb: 0xBDB962),
                      4: SKColor(rgb: 0xD8D35C),
                      5: SKColor(rgb: 0xE99528),
                      6: SKColor(rgb: 0xBD9562),
                      7: SKColor(rgb: 0xD8A25C),
                      8: SKColor(rgb: 0xF18800),
                      9: SKColor(rgb: 0xFF9000),
                      10: SKColor(rgb: 0x9CEAEF),
                      11: SKColor(rgb: 0x07BEB8),
                      12: SKColor(rgb: 0x216596),
                      13: SKColor(rgb: 0x436279),
                      14: SKColor(rgb: 0x436279),
                      15: SKColor(rgb: 0x406C8B),
                      16: SKColor(rgb: 0x075E9B)])
        
        let light = ColorSchema(
            bgColor: .gray,
            sceneBgColor: .white,
            cellBgColor: .gray,
            cellBlockedBgColor: .darkGray,
            colors: [0: SKColor(rgb: 0x07BEB8),
                     1: SKColor(rgb: 0x0568AE),
                     2: SKColor(rgb: 0xE9E228),
                     3: SKColor(rgb: 0xBDB962),
                     4: SKColor(rgb: 0xD8D35C),
                     5: SKColor(rgb: 0xE99528),
                     6: SKColor(rgb: 0xBD9562),
                     7: SKColor(rgb: 0xD8A25C),
                     8: SKColor(rgb: 0xF18800),
                     9: SKColor(rgb: 0xFF9000),
                     10: SKColor(rgb: 0x9CEAEF),
                     11: SKColor(rgb: 0x07BEB8),
                     12: SKColor(rgb: 0x216596),
                     13: SKColor(rgb: 0x436279),
                     14: SKColor(rgb: 0x436279),
                     15: SKColor(rgb: 0x406C8B),
                     16: SKColor(rgb: 0x075E9B)])
        
        allPalettes = [
            .Dark: gray,
            .Light: light]
        
        currentPalette = allPalettes[.Dark]!
    }
    
    func color(value: Int) -> SKColor {
    
        let color = currentPalette.colors[value]
        assert(color != nil, "PaletteManager: color for value \(value) not found")
        return color!
    }
    
    func cellBgColor() -> SKColor {
        return currentPalette.cellBgColor
        // .gray
    }
    
    func sceneBgColor() -> SKColor {
        return currentPalette.sceneBgColor
//        return .white
    }
    
    func cellBlockedBgColor() -> SKColor {
        return currentPalette.cellBlockedBgColor
//        return .darkGray
    }
    
    func switchPalette(to colorSchemaType: ColorSchemaType) {
        
        let pal = allPalettes[colorSchemaType]
        assert(pal != nil, "Palette \(colorSchemaType) not exist")
        currentPalette = pal!
    }
    
    /*static private let colors: Dictionary =
        [0: SKColor(rgb: 0x07BEB8),
         1: SKColor(rgb: 0x0568AE),
         2: SKColor(rgb: 0xE9E228),
         3: SKColor(rgb: 0xBDB962),
         4: SKColor(rgb: 0xD8D35C),
         5: SKColor(rgb: 0xE99528),
         6: SKColor(rgb: 0xBD9562),
         7: SKColor(rgb: 0xD8A25C),
         8: SKColor(rgb: 0xF18800),
         9: SKColor(rgb: 0xFF9000),
         10: SKColor(rgb: 0x9CEAEF),
         11: SKColor(rgb: 0x07BEB8),
         12: SKColor(rgb: 0x216596),
         13: SKColor(rgb: 0x436279),
         14: SKColor(rgb: 0x436279),
         15: SKColor(rgb: 0x406C8B),
         16: SKColor(rgb: 0x075E9B)]*/
    
}
