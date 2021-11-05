//
//  BitBoard.swift
//  MegaTicTacToe
//
//  Created by Jules Walzer-Goldfeld on 6/26/20.
//  Copyright © 2020 Jules Walzer-Goldfeld. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

//may run into problem of directions of bit and their represenation being wrong

// 1 is not finished, 2 is tie, 4 is XWIn, 8 is OWIn
class BitBoard: NSCopying {
    var bitBoardX: [UInt16]
    var bitBoardO: [UInt16]
    var bitLegalBoards: UInt16
    var XTurn: Bool
    
    static var refreshCount = 0
    
    var miniWins: [Status]
    var bitWinStatus: Status
        
    init() {
        bitLegalBoards = 0b111_111_111
        bitBoardX = [UInt16]()
        bitBoardO = [UInt16]()
        XTurn = true
        
        miniWins = [Status]()
        bitWinStatus = .notFinished
        
        for _ in 0 ..< 9 {
            bitBoardX.append(0b0)
            bitBoardO.append(0b0)
            miniWins.append(.notFinished)
        }
    }
    
    init(bitBoardX: [UInt16], bitBoardO: [UInt16], bitLegalBoards: UInt16, XTurn: Bool, miniWins:[Status], bitWinStatus: Status) {
        self.bitBoardX = bitBoardX
        self.bitBoardO = bitBoardO
        self.bitLegalBoards = bitLegalBoards
        self.XTurn = XTurn
        self.miniWins = miniWins
        self.bitWinStatus = bitWinStatus
    }
    
    init(megaBoard: MegaBoard) {
        self.XTurn = megaBoard.XTurn
        self.bitLegalBoards = 0b0

        for i in megaBoard.legalBoards {
            self.bitLegalBoards = self.bitLegalBoards | 1 << i
        }
        
        self.bitBoardX = [UInt16]()
        self.bitBoardO = [UInt16]()
        for _ in 0 ..< 9 {
            bitBoardX.append(0b0)
            bitBoardO.append(0b0)
        }
        for i in 0 ..< 9 {
            for j in 0 ..< 9 {
                switch megaBoard.megaBoard[i].miniBoard[j] {
                case .X: self.bitBoardX[i] = self.bitBoardX[i] | 1 << j
                case .O: self.bitBoardO[i] = self.bitBoardO[i] | 1 << j
                default: break
                }
            }
        }
        self.miniWins = megaBoard.miniWins
        self.bitWinStatus = megaBoard.megaWinStatus
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        var bitBoardXCopy = [UInt16]()
        var bitBoardOCopy = [UInt16]()
        
        for i in 0 ..< 9 {
            bitBoardXCopy.append(bitBoardX[i])
            bitBoardOCopy.append(bitBoardO[i])
        }
        
        let copy = BitBoard(bitBoardX: bitBoardXCopy, bitBoardO: bitBoardOCopy, bitLegalBoards: bitLegalBoards, XTurn: XTurn, miniWins: miniWins, bitWinStatus: bitWinStatus)
        return copy
    }
    
    // takes the location of the move... returns whether or not the move happened
    // if it happened, it updates the necessary pieces
    public func makeMove(boardNumber: Int, location: Int) -> Bool {
        // confirm that the move is legal
        guard isLegal(boardNumber: boardNumber, location: location) else {
            return false
        }
        
        //make the move
        if XTurn {
            bitBoardX[boardNumber] = bitBoardX[boardNumber] | 1 << location
        } else {
            bitBoardO[boardNumber] = bitBoardO[boardNumber] | 1 << location

        }
        
        //check if miniresult occured
        miniWins[boardNumber] = getMiniResult(boardNumber: boardNumber)
        
        // if miniResult ocurred
        if miniWins[boardNumber] != .notFinished {
            let megaWin = WinCases.didWinGeneric(board: miniWins)
            if megaWin.winStatus != .notFinished {
                // if mega win occured, no board is legal, empty wins fade to blank, return true
                bitLegalBoards = 0b0 // maybe dont need to have this
                bitWinStatus = megaWin.winStatus
                return true
            }
        }
        
        // update bitLegalBoards
        // if no result yet in miniboard moved in, that is legal board
        if miniWins[location] == .notFinished {
            self.bitLegalBoards = 1 << location
        } else {
            //else for each miniBoard, if no result, add to legal boards
            self.bitLegalBoards = 0b0
            for i in 0 ..< 9 {
                if miniWins[i] == .notFinished {
                    self.bitLegalBoards = self.bitLegalBoards | 1 << i
                }
            }
        }
        XTurn.toggle()
        return true
    }
    
    // check if a move is legal by confirming the board number is legal and the location is empty
    private func isLegal(boardNumber: Int, location: Int) -> Bool {
        if self.bitLegalBoards & 1 << boardNumber == 1 << boardNumber {
            return ~(bitBoardX[boardNumber] | bitBoardO[boardNumber]) & 1 << location == 1 << location
        }
        return false
    }
    
    private func getMiniResult(boardNumber: Int) -> Status {
        if BitBoard.isWin(bitBoardX[boardNumber]) {
            return .X
        } else if BitBoard.isWin(bitBoardX[boardNumber]) {
            return .O
        } else if bitBoardX[boardNumber] | bitBoardO[boardNumber] == 0b111_111_111 {
            return .tie
        }
        return .notFinished
    }
    
    //produce all possible moves
    public func allPossibleMoves() -> [(boardNumber: Int, emptyLocation: Int)] {
        var result = [(boardNumber: Int, emptyLocation: Int)]()
        var count = 0
        // for each legal board
        for legalBoard in 0 ..< 9 {
            if bitLegalBoards & 1 << legalBoard == 1 << legalBoard {
                count += 1
                for legalEmptyLocation in 0 ..< 9 {
                    let emptyLocations = ~(bitBoardX[legalBoard] | bitBoardO[legalBoard])
                    let mask: UInt16 = 1 << legalEmptyLocation
                    if emptyLocations & mask == mask {
                        result.append((boardNumber: legalBoard, emptyLocation: legalEmptyLocation))
                    }
                }
            }
        }
        return result
    }
    
    // check if a given board of X's or O's (not both) has a win
    static func isWin (_ board: UInt16) -> Bool {
        if BitBoard.checkWinHorizontal(board) || BitBoard.checkWinVertical(board) || BitBoard.checkWinDiagonal(board) {
            return true
        }
        return false
    }
    
    // checks if the intersection of x and o boards have a result
    static func hasAResult(boardX: UInt16, boardO: UInt16) -> Bool {
        if BitBoard.isWin(boardX) || BitBoard.isWin(boardO) {
            return true
        }
        return boardX | boardO == 0b111_111_111
    }
    
    // checks if the intersecion of two boards are full
    static func isFull(boardX: UInt16, boardO: UInt16) -> Bool {
        return boardX | boardO == 0b111_111_111
    }
    
    // these check for the various wins
    static func checkWinHorizontal(_ board: UInt16) -> Bool {
        return ((board & board >> 1) & board >> 2) & 0b001_001_001 != 0b0
    }
    
    static func checkWinVertical(_ board: UInt16) -> Bool {
        return (board & board >> 3) & board >> 6 != 0b0
    }
    
    static func checkWinDiagonal(_ board: UInt16) -> Bool {
        let a = (board & 0b100_010_001 == 0b100_010_001) || (board & 0b001_010_100 == 0b001_010_100)
        if a {
            
        }
        return a
    }
    
}
