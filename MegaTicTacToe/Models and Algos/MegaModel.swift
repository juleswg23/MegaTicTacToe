//
//  MegaModel.swift
//  MegaTicTacToe
//
//  Created by Jules Walzer-Goldfeld on 6/22/20.
//  Copyright © 2020 Jules Walzer-Goldfeld. All rights reserved.
//

import SwiftUI

class MegaModel: ObservableObject {
    @Published var XColor: Color = .secondary
    @Published var OColor: Color = .secondary
    @Published var didUpdate = true
    
    var state: MegaBoard
    
    init() {
        state = MegaBoard()
    }
    
    func newGame() {
        self.state = MegaBoard()
        didUpdate.toggle()
    }
    
    func playAIMove(depthTime: Double) -> Void {
        self.state.AIMove(depthTime: depthTime)
        
    }
}

class WinCases {
    init() {}
    
    static let cases: [[Int]] =
        [
            [0, 1, 2], [3, 4, 5], [6, 7, 8],
            [0, 3, 6], [1, 4, 7], [2, 5, 8],
            [0, 4, 8], [2, 4, 6]
        ]
    static func didWinGeneric (board: [Status]) -> (winStatus: Status, winLocation: WinningLocation) {
        for (index, winCase) in cases.enumerated() {
            if .notFinished != board[winCase[0]] && board[winCase[0]] == board[winCase[1]] && board[winCase[1]] == board[winCase[2]] {
                var winLocation: WinningLocation

                switch index {
                case 0: winLocation = .hTop
                case 1: winLocation = .hMid
                case 2: winLocation = .hBot
                case 3: winLocation = .vLeft
                case 4: winLocation = .vMid
                case 5: winLocation = .vRight
                case 6: winLocation = .tLeft
                default: winLocation = .tRight
                }
                return (board[winCase[0]], winLocation)
            }
        }
        
        for element in board {
            if element == .notFinished {
                return (.notFinished, .none)
            }
        }
        
        return (.tie, .none)
        
    }
}
