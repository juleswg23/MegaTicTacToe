//
//  BitState.swift
//  MegaTicTacToe
//
//  Created by Jules Walzer-Goldfeld on 6/27/20.
//  Copyright © 2020 Jules Walzer-Goldfeld. All rights reserved.
//

import Foundation

class BitState: NSCopying, CustomStringConvertible {
    private var bitBoard: BitBoard
    private var visitCount: Int = 0
    private var winCount: Double = 0.0
    
    init(bitBoard: BitBoard, visitCount: Int, winCount: Double) {
        self.bitBoard = bitBoard
        self.visitCount = visitCount
        self.winCount = winCount
    }
    
    init(bitBoard: BitBoard) {
        self.bitBoard = bitBoard
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let bitBoardCopy = bitBoard.copy() as! BitBoard
        let copy = BitState(bitBoard: bitBoardCopy, visitCount: visitCount, winCount: winCount)
        return copy
    }
    
    var description: String {
        var str = "BitState:\n"
        str += "Visit Count: \(visitCount), Win Count: \(winCount)\n"
        str += "\(bitBoard)\n"
        
        return str
    }
    
    public func getBitBoard() -> BitBoard {
        return self.bitBoard
    }
    
    public func setBitBoard(_ bitBoard: BitBoard) -> Void {
        self.bitBoard = bitBoard
    }
    
    public func getVisitCount() -> Int {
        return self.visitCount
    }
    
    public func incrementVisitCount() -> Void {
        self.visitCount += 1
    }
    
    public func getWinCount() -> Double {
        return self.winCount
    }
    
    public func addToWinCount(_ count: Double) -> Void {
        self.winCount += count
    }
    
    public func getAllPossibleStates() -> [BitState] {
        var result = [BitState]()
        for move in bitBoard.allPossibleMoves() {
            let newState = self.copy() as! BitState
            _ = newState.getBitBoard().makeMove(boardNumber: move.boardNumber, location: move.emptyLocation)
            result.append(newState)
        }
        return result
    }
    
    public func randomPlay() -> Void {
        let possibleMoves = self.bitBoard.allPossibleMoves()
        if possibleMoves.count == 0 {
            
        }
        let move = possibleMoves.randomElement()!
        _ = bitBoard.makeMove(boardNumber: move.boardNumber, location: move.emptyLocation)
    }
}
