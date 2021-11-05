//
//  GameView.swift
//  TicTacToe
//
//  Created by Jules Walzer-Goldfeld on 6/13/20.
//  Copyright © 2020 Jules Walzer-Goldfeld. All rights reserved.
//

import SwiftUI

struct GameView: View {
    @State private var winningLocation: WinningLocation = .tLeft
        
    let width: CGFloat
    let boardNumber: Int
    
    @Binding var XColor: Color
    @Binding var OColor: Color
    @Binding var board: MiniBoard
    @Binding var winStatus: Status
    
    var clickedAction: (Int, Int) -> Void
    
    var body: some View {
        GridView { row, col in
            TileView(lineWidth: 2.5, frameSize: self.width/5.3, status: self.$board.miniBoard[row * 3 + col], XColor: self.$XColor, OColor: self.$OColor) {
                self.clickedAction(self.boardNumber, row * 3 + col)
            }
            .padding(.all, self.width/26)
        }
        .background(
            BoardBackground()
                .stroke(ColorManager.primary, style: StrokeStyle(lineWidth: 5.25, lineCap: .round))
                .frame(width: self.width * 0.8, height: self.width * 0.8)

        )
        .opacity(winStatus == .notFinished ? 1.0 : 0.25)
        .overlay(
            XTile(draw: winStatus == .X ? CGFloat(1.0) : CGFloat(0.0))
                .stroke(ColorManager.secondary, style: StrokeStyle(lineWidth: 7, lineCap: .round))
                .opacity(winStatus == .X ? 1.0 : 0.0)
                .frame(width: self.width * 0.65, height: self.width * 0.65)
                .animation(.easeInOut(duration: 1.5))
        )
        .overlay(
            OTile(draw: winStatus == .O ? 1.0 : 0.0)
                .stroke(ColorManager.secondary, lineWidth: 7)
                .opacity(winStatus == .O ? 1.0 : 0.0)
                .frame(width: self.width * 0.65, height: self.width * 0.65)
                .animation(.easeInOut(duration: 1.5))
        )
        .padding(.all, self.width/12.5)
    }
    
}
