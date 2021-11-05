//
//  TileView.swift
//  TicTacToe
//
//  Created by Jules Walzer-Goldfeld on 6/11/20.
//  Copyright © 2020 Jules Walzer-Goldfeld. All rights reserved.
//

import SwiftUI

enum Status {
    case X, O
    case notFinished
    case tie
}

struct TileView: View {
    let lineWidth: CGFloat
    let frameSize: CGFloat
    
    @Binding var status: Status
    @Binding var XColor: Color
    @Binding var OColor: Color

    var clicked: () -> Void
    
    var body: some View {
        return ZStack {
            XTile(draw: CGFloat(self.status == .X ? 1.0 : 0.0))
                .stroke(XColor, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .opacity(self.status == .X ? 1.0 : 0.0)
                .frame(width: frameSize * 0.87, height: frameSize * 0.87)
            
            OTile(draw: self.status == .O ? 1.0 : 0.0)
                .stroke(OColor, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .opacity(self.status == .O ? 1.0 : 0.0)
                .frame(width: frameSize * 0.87, height: frameSize * 0.87)
        }
        .frame(width: frameSize, height: frameSize)
        .contentShape(Rectangle())
        .onTapGesture(perform: clicked)
        .animation(.easeIn(duration: 1.0))
    }

}

//maybe change to if status empty at some point
