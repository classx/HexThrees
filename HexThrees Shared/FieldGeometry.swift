//
//  FieldGeometry.swift
//  HexThrees
//
//  Created by Ilja Stepanow on 25.06.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation
import SpriteKit

class FieldGeometry {
    
    private let gap = 5.0
    private var fieldHalfHeight : CGFloat = 0
    
    private let hexRad: Double
    private let hexCellPath: CGPath
    private let outlinePath: CGPath
    private let cellWidth: Double
    private let cellHeight: Double
    
    init(screenWidth: CGFloat, fieldSize: Int) {
        
        self.hexRad = FieldGeometry.calculateHexRad(
            viewWidth: screenWidth,
            hexCount: fieldSize,
            gap: gap)
        
        self.hexCellPath = FieldGeometry.createPath(rad: self.hexRad)
        self.outlinePath = FieldGeometry.createPath(rad: self.hexRad + self.gap)
        
        self.cellWidth = hexRad * 1.732
        self.cellHeight = hexRad * 2
        
        let furthestCellCoord = ToScreenCoord(AxialCoord(fieldSize - 1, fieldSize - 1))
        self.fieldHalfHeight = furthestCellCoord.y / 2.0
    }
    
    func createHexCellShape() -> SKShapeNode {
        
        return createShape (path: self.hexCellPath)
    }
    
    func createOutlineShape() -> SKShapeNode {
        
        return createShape (path: self.outlinePath)
    }
    
    private func createShape(path: CGPath) -> SKShapeNode {
        
        let hexShape = SKShapeNode()
        hexShape.path = path
        return hexShape
    }
    
    class func calculateHexRad(viewWidth: CGFloat, hexCount: Int, gap: Double) -> Double {
        
        let fieldW = Double(viewWidth * 0.9)
        
        return ((fieldW + gap) / Double(hexCount) - gap) / 1.732
    }
    
    class func createPath(rad: Double) -> CGPath {
        
        let hexPath = CGMutablePath.init()
        
        let xCoef = 1.732 * 0.5
        let yCoef = 0.5
        
        hexPath.move(to: CGPoint.init(x: 0.0, y: rad))
        hexPath.addLine(to: CGPoint.init(x: rad * xCoef, y: rad * yCoef))
        hexPath.addLine(to: CGPoint.init(x: rad * xCoef, y: -rad * yCoef))
        hexPath.addLine(to: CGPoint.init(x: 0.0, y: -rad))
        hexPath.addLine(to: CGPoint.init(x: -rad * xCoef, y: -rad * yCoef))
        hexPath.addLine(to: CGPoint.init(x: -rad * xCoef, y: rad * yCoef))
        hexPath.addLine(to: CGPoint.init(x: 0.0, y: rad))
        
        return hexPath
    }
    
    func ToScreenCoord(_ a : AxialCoord) -> CGPoint {
        
        //@todo: there are a lot of conversations between float and double. Google difference, use only one mostly
        let w = Float(self.cellWidth + self.gap)
        let h = Float(self.cellHeight + self.gap * 1.732)
        
        let x = Float(a.c - a.r) * 0.5 * w
        let y = Float(a.c + a.r) * (w * 0.5 + h / (2.0 * 1.732))
        
        
        return CGPoint(
            x: CGFloat(x),
            y: CGFloat(y) - self.fieldHalfHeight)
    }
    
    func ToScreenCoord(_ a : CubeCoord) -> CGPoint {
        
        return ToScreenCoord(AxialCoord(a))
    }
}
