//
//  WinningLocation.swift
//  MegaTicTacToe
//
//  Created by Jules Walzer-Goldfeld on 6/22/20.
//  Copyright © 2020 Jules Walzer-Goldfeld. All rights reserved.
//

import SwiftUI

struct WinningLineView: Shape {
    var location: WinningLocation
    
    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: rect.maxX * CGFloat(location.coef()[0]), y: rect.maxY * CGFloat(location.coef()[1])))
        path.addLine(to: CGPoint(x: rect.maxX * CGFloat(location.coef()[2]), y: rect.maxY * CGFloat(location.coef()[3])))

        return path
    }
}
