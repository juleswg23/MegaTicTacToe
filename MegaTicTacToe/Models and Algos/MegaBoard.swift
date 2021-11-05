//
//  MegaBoard.swift
//  MegaTicTacToe
//
//  Created by Jules Walzer-Goldfeld on 6/28/20.
//  Copyright © 2020 Jules Walzer-Goldfeld. All rights reserved.
//

import Foundation

class MegaBoard: NSCopying, CustomStringConvertible {
    var legalBoards: [Int]
    var miniWins: [Status]
    var megaWinStatus: Status = .notFinished // change this and XTurn
    var XTurn: Bool = true
    var megaBoard: [MiniBoard]
    
    init() {
        self.megaBoard = [MiniBoard]()
        self.miniWins = [Status]()
        self.legalBoards = [0, 1, 2, 3, 4, 5, 6, 7, 8]
        newGame()
    }
    
    init(legalBoards: [Int], miniWins: [Status], megaWinStatus: Status, XTurn: Bool, megaBoard: [MiniBoard]) {
        self.legalBoards = legalBoards
        self.miniWins = miniWins
        self.megaWinStatus = megaWinStatus
        self.XTurn = XTurn
        self.megaBoard = megaBoard
    }
    
    init(bitBoard: BitBoard) {
        self.megaBoard = [MiniBoard]()
        self.miniWins = [Status]()
        self.legalBoards = [Int]()
        newGame()
        
        for i in 0 ..< 9 {
            if bitBoard.bitLegalBoards & 1 << i == 1 << i {
                self.legalBoards.append(i)
            }
        }
        
        for i in 0 ..< 9 {
            for j in 0 ..< 9 {
                if bitBoard.bitBoardX[i] & 1 << j == 1 << j {
                    self.megaBoard[i].miniBoard[j] = .X
                } else if bitBoard.bitBoardO[i] & 1 << j == 1 << j {
                    self.megaBoard[i].miniBoard[j] = .O
                }
            }
        }
        
        self.miniWins = bitBoard.miniWins
        self.megaWinStatus = bitBoard.bitWinStatus
        self.XTurn = bitBoard.XTurn
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        var megaBoardCopy = [MiniBoard]()
        for miniBoard in megaBoard {
            megaBoardCopy.append(miniBoard.copy() as! MiniBoard)
        }
        let copy = MegaBoard(legalBoards: legalBoards, miniWins: miniWins, megaWinStatus: megaWinStatus, XTurn: XTurn, megaBoard: megaBoardCopy)
        return copy
    }
    
    var description: String {
        var str = "MegaBoard:\n"
        str += "Legal: \(legalBoards)\n"
        str += "MiniWins: \(miniWins)\n"
        str += "MegaWinStatus: \(megaWinStatus), XTurn: \(XTurn)\n"
        return str
    }
        
    func newGame() -> Void {
        megaBoard = [MiniBoard]()
        miniWins = [Status]()
        for _ in 0 ..< 9 {
            megaBoard.append(MiniBoard())
            miniWins.append(.notFinished)
        }
    }
    
    func AIMove(depthTime: Double) {
//        let ai = BitMCTSTreeSearch(depthTime: depthTime)
//        let bitAIMove = ai.findNextMove(bitBoard: BitBoard(megaBoard: self))
//        let aiMove = MegaBoard(bitBoard: bitAIMove)
//        let aiGroup = DispatchGroup()
        let ai = MCTSTreeSearch(depthTime: depthTime)
//        var aiMove: MegaBoard?
//        aiGroup.enter()
//        DispatchQueue.main.async {
            let aiMove = ai.findNextMove(megaBoard: self)
//            aiGroup.leave()
//        }
//        aiGroup.notify(queue: .main) {
//            print("here")
            self.legalBoards = aiMove.legalBoards
            self.miniWins = aiMove.miniWins
            self.megaWinStatus = aiMove.megaWinStatus
            self.megaBoard = aiMove.megaBoard
            self.XTurn = aiMove.XTurn
       // }
    }
    
    func makeMove(boardNumber: Int, index: Int, winLocation: WinningLocation) -> (winLocation: WinningLocation, legal: Bool) {
        // check if move occurred in a legal board
        guard legalBoards.contains(boardNumber) else {
            return (winLocation, false)
        }
        
        // do move actions IFF old status is empty and we are in legal territory
        // maybe can do this
        if megaBoard[boardNumber].isLegal(index: index) {
            miniWins[boardNumber] = megaBoard[boardNumber].makeMove(index: index, to: XTurn ? .X : .O)
            XTurn.toggle()
            
            // if a mini result occured
            if miniWins[boardNumber] != .notFinished {
                // check for mega win
                let megaWin = WinCases.didWinGeneric(board: miniWins)
                if megaWin.winStatus != .notFinished {
                    
                    // if mega win occured, no board is legal, empty wins fade to blank, return true
                    legalBoards = [Int]()
                    for i in miniWins.indices {
                        if miniWins[i] == .notFinished {
                            miniWins[i] = .tie
                        }
                    }
                    megaWinStatus = megaWin.winStatus
                    return (megaWin.winLocation, true)
                }
            }
            
            // if no mega win occured properly update the legal boards
            if miniWins[index] == .notFinished {
                legalBoards = [index]
            } else {
                legalBoards = []
                for (index, winner) in miniWins.enumerated() {
                    if winner == .notFinished {
                        legalBoards.append(index)
                    }
                }
            }
        }
        return (.none, true)
    }
    
    public func allPossibleMoves() -> Array<((boardNumber: Int, index: Int))> {
        var result = [(boardNumber: Int, index: Int)]()
        for boardNumber in legalBoards {
            for (index, Status) in self.megaBoard[boardNumber].miniBoard.enumerated() {
                if Status == .notFinished {
                    result.append((boardNumber: boardNumber, index: index))
                }
            }
        }
        return result
    }
}
