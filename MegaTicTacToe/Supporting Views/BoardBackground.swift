//
//  BoardBackground.swift
//  MegaTicTacToe
//
//  Created by Jules Walzer-Goldfeld on 6/17/20.
//  Copyright © 2020 Jules Walzer-Goldfeld. All rights reserved.
//

import SwiftUI

struct BoardBackground: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY/3))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY/3))
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY*2/3))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY*2/3))
        
        path.move(to: CGPoint(x: rect.maxX/3, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX/3, y: rect.maxY))
        path.move(to: CGPoint(x: rect.maxX*2/3, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX*2/3, y: rect.maxY))
        
        return path
    }
}
