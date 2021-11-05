//
//  BitMCTS.swift
//  MegaTicTacToe
//
//  Created by Jules Walzer-Goldfeld on 6/27/20.
//  Copyright © 2020 Jules Walzer-Goldfeld. All rights reserved.
//

// 1 is not finished, 2 is tie, 4 is XWIn, 8 is OWIn
import SwiftUI

class BitMCTSTreeSearch {
    var aiPlayer: Status = .notFinished
    var opponent: Status = .notFinished
    var depthTime: Double
    var root: BitMCTSNode?
    
    init(depthTime: Double) {
        self.depthTime = depthTime
    }
    
    public func findNextMove(bitBoard: BitBoard) -> BitBoard {
        print("\nRunning for \(depthTime) seconds.")
        aiPlayer = bitBoard.XTurn ? .X : .O
        opponent = bitBoard.XTurn ? .O : .X
        let rootNode = BitMCTSNode(bitState: BitState(bitBoard: bitBoard)).copy() as! BitMCTSNode
        root = rootNode

        var count = 0
        let end = DispatchTime.now() + depthTime
        while (DispatchTime.now() < end) { // while time not up
            // got to most promising leaf
            let promisingNode = selectPromisingNode(rootNode)
            if promisingNode.getState().getBitBoard().bitWinStatus == .notFinished {
                expandNode(promisingNode)
            }
            
            var nodeToExplore = promisingNode
            if promisingNode.getChildren().count > 0 {
                nodeToExplore = promisingNode.getRandomChild()
            }
    
            let playoutResult: Status = simulateRandomPlayout(node: nodeToExplore) // switched
            backPropogation(node: nodeToExplore, result: playoutResult)
            count += 1
        }
        
        var max = Double(Int.min)
        var bestNode: BitMCTSNode? //may ignore game over situations
                
        for (index, node) in rootNode.getChildren().enumerated() {
            let nodeScore = node.getState().getWinCount() / Double(node.getState().getVisitCount())
            print("Index: \(index), \(node.getState().getWinCount())/\(node.getState().getVisitCount()): gives \(nodeScore)")

            if nodeScore > max {
                max = nodeScore
                bestNode = node
            }
        }
        print("Choice \(bestNode?.getState().getWinCount().description ?? "error")/\(bestNode?.getState().getVisitCount().description ?? "error"): gives \(max)")
        print("Simulated \(count) runs.")
        
        return bestNode?.getState().getBitBoard() ?? bitBoard
    }
    
    private func selectPromisingNode(_ rootNode: BitMCTSNode) -> BitMCTSNode {
        var node = rootNode
        while (node.getChildren().count != 0) {
            node = BitUCT.findBestNodeWithUCT(node: node)
        }
        return node
    }
    
    private func expandNode(_ node: BitMCTSNode) -> Void {
        let possibleStates: [BitState] = node.getState().getAllPossibleStates()
        for state in possibleStates {
            let newNode: BitMCTSNode = BitMCTSNode(bitState: state)
            newNode.setParent(node)
            node.addToChildren(newNode)
        }
    }
    
    private func simulateRandomPlayout(node: BitMCTSNode) -> Status {
        let tempNode = node.copy() as! BitMCTSNode
        let tempState = tempNode.getState()
        var boardStatus = tempNode.getState().getBitBoard().bitWinStatus
        if boardStatus == opponent {
            node.getParent()!.getState().addToWinCount(Double(Int.min))
            print("Oppo")
            return boardStatus
        }
        while (boardStatus == .notFinished) {
            tempState.randomPlay()
            boardStatus = tempState.getBitBoard().bitWinStatus
        }
        return boardStatus
    }
    
    private func backPropogation(node: BitMCTSNode, result: Status) -> Void {
        var tempNode: BitMCTSNode? = node
        while (tempNode != nil) {
            tempNode!.getState().incrementVisitCount()
            if (tempNode!.getState().getBitBoard().XTurn ? .O : .X) == result { // swapped
                tempNode!.getState().addToWinCount(1.0)
            } else if result == .tie {
                tempNode!.getState().addToWinCount(0.5)
            }
            tempNode = tempNode!.getParent()
        }
    }
}

public class BitUCT {
    public static func uctValue(totalVisit: Int, nodeWinCount: Double, nodeVisit: Int) -> Double {
        if nodeVisit == 0 {
            return Double(Int.max);
        }
        
        let a = nodeWinCount / Double(nodeVisit)
        let b = 1.41 * sqrt(log2(Double(totalVisit)) / Double(nodeVisit))
        return a + b
    }
 
    static func findBestNodeWithUCT(node: BitMCTSNode) -> BitMCTSNode {
        let parentVisit = node.getState().getVisitCount()
        var best = node.getChildren().first!
        var max = Double(Int.min)
        
        for child in node.getChildren() {
            let newUCT = uctValue(totalVisit: parentVisit, nodeWinCount: child.getState().getWinCount(), nodeVisit: child.getState().getVisitCount())
            if newUCT > max {
                max = newUCT
                best = child
            }
        }
        return best
    }
}

