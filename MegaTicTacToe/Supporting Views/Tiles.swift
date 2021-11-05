//
//  Tiles.swift
//  MegaTicTacToe
//
//  Created by Jules Walzer-Goldfeld on 6/18/20.
//  Copyright © 2020 Jules Walzer-Goldfeld. All rights reserved.
//

import SwiftUI

struct OTile: Shape {
    var draw: Double
    
    var animatableData: Double {
        get { return self.draw }
        set { self.draw = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let offset = 180.0
        
        path.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: rect.width/2, startAngle: .degrees(0 - offset), endAngle: .degrees(360 * draw - offset), clockwise: false)
        
        return path
    }
}

struct XTile: Shape {
    var draw: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX * draw, y: rect.maxY * draw))
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX * draw, y: -1 * rect.maxY * draw + rect.maxY))

        return path
    }
    
    var animatableData: CGFloat {
        get { return draw }
        set { self.draw = newValue }
    }
}
