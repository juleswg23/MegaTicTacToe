//
//  MegaView.swift
//  MegaTicTacToe
//
//  Created by Jules Walzer-Goldfeld on 6/17/20.
//  Copyright © 2020 Jules Walzer-Goldfeld. All rights reserved.
//

import SwiftUI

struct MegaView: View {
    let width: CGFloat
    @ObservedObject var model: MegaModel
    @State private var winLocation: WinningLocation = .none
    @State var depthTime = 2.5
    @State var buttonsEnabled = true
    
    var thirdWidth: CGFloat {
        width/3
    }
    
    func clickedAction(boardNumber: Int, index: Int) -> Void {
        if buttonsEnabled {
            let moveResult = self.model.state.makeMove(boardNumber: boardNumber, index: index, winLocation: winLocation)
            if moveResult.legal {
                self.winLocation = moveResult.winLocation
                self.model.didUpdate.toggle()
            }
        }
    }
    
    var body: some View {
        GridView { row, col in
            GameView(width: self.thirdWidth, boardNumber: row*3 + col, XColor: self.$model.XColor, OColor: self.$model.OColor, board: self.$model.state.megaBoard[row*3 + col], winStatus: self.$model.state.miniWins[row*3 + col], clickedAction: self.clickedAction)
                .background(ColorManager.secondary
                    .frame(width: self.thirdWidth * 0.9, height: self.thirdWidth * 0.9)
                    .opacity(self.model.state.legalBoards.contains(row*3 + col) ? 0.25 : 0)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                    .animation(.easeInOut(duration: 1.0))
            )
        }
            
        .background(
            BoardBackground()
                .stroke(ColorManager.primary, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                .frame(width: self.width * 0.95, height: self.width * 0.95)
        )
            .overlay(WinningLineView (location: self.winLocation)
                .stroke(model.state.megaWinStatus == .X || model.state.megaWinStatus == .O ? ColorManager.win : .secondary, style: StrokeStyle(lineWidth: model.state.megaWinStatus == .X || model.state.megaWinStatus == .O ? 95 : 0, lineCap: .round))
                .frame(width: self.width * 0.95, height: self.width * 0.95)
                .opacity(model.state.megaWinStatus == .X || model.state.megaWinStatus == .O ? 0.5 : 0.0)
                .animation(.easeIn(duration: 1.5))
        )
    }
}
