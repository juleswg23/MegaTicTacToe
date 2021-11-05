//
//  BitModel.swift
//  MegaTicTacToe
//
//  Created by Jules Walzer-Goldfeld on 6/27/20.
//  Copyright © 2020 Jules Walzer-Goldfeld. All rights reserved.
//

import SwiftUI

// move this
enum Status {
    case X, O
    case tie
    case notFinished
}

class BitModel: ObservableObject {
    @Published var XColor: Color = .secondary
    @Published var OColor: Color = .secondary
    @Published var didUpdate = true
    
    var bitBoard: BitBoard
    
    init() {
        bitBoard = BitBoard()
    }
    
    func newGame() {
        self.bitBoard = BitBoard()
        didUpdate.toggle()
    }
    
    func AIMove(depthTime: Double) {
        let ai = BitMCTSTreeSearch(depthTime: depthTime)
        let aiMove = ai.findNextMove(bitBoard: bitBoard)
        self.bitBoard.bitBoardX = aiMove.bitBoardX
        self.bitBoard.bitBoardO = aiMove.bitBoardO
        self.bitBoard.bitLegalBoards = aiMove.bitLegalBoards
        self.bitBoard.XTurn = aiMove.XTurn
    }
}
