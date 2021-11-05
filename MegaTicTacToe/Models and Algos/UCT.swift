//
//  UCT.swift
//  MegaTicTacToe
//
//  Created by Jules Walzer-Goldfeld on 6/25/20.
//  Copyright © 2020 Jules Walzer-Goldfeld. All rights reserved.
//

import Foundation

public class UCT {
    public static func uctValue(totalVisit: Int, nodeWinCount: Double, nodeVisit: Int) -> Double {
        if nodeVisit == 0 {
            return Double(Int.max);
        }
        
        let a = nodeWinCount / Double(nodeVisit)
        let b = 1.41 * sqrt(log(Double(totalVisit)) / Double(nodeVisit))
        return a + b
    }
 
    static func findBestNodeWithUCT(node: MCTSNode) -> MCTSNode {
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
