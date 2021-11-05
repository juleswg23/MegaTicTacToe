//
//  MiniBoard.swift
//  MegaTicTacToe
//
//  Created by Jules Walzer-Goldfeld on 6/28/20.
//  Copyright © 2020 Jules Walzer-Goldfeld. All rights reserved.
//

import Foundation

class MiniBoard: NSCopying, CustomStringConvertible {
    var miniBoard: [Status]
    
    init() {
        miniBoard = [Status]()
        for _ in 0 ..< 9 {
            miniBoard.append(.notFinished)
        }
    }
    
    init(miniBoard: [Status]) {
        self.miniBoard = miniBoard
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = MiniBoard(miniBoard: miniBoard)
        return copy
    }
    
    public var description: String {
        var str = "MiniBoard\n["
        for i in 0...9 {
            str += "\(self.miniBoard[i]) "
        }
        return str + "]"
    }
    
    public func isLegal(index: Int) -> Bool {
        return self.miniBoard[index] == .notFinished
    }
    
    func makeMove(index: Int, to Status: Status) -> Status {
        guard isLegal(index: index) else {
            fatalError()
        }
        self.miniBoard[index] = Status
        return WinCases.didWinGeneric(board: self.miniBoard).winStatus
    }
}
