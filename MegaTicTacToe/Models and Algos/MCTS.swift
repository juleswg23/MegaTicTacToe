//
//  MCTS.swift
//  MegaTicTacToe
//
//  Created by Jules Walzer-Goldfeld on 6/24/20.
//  Copyright © 2020 Jules Walzer-Goldfeld. All rights reserved.
//

import Foundation

class GameState: NSCopying, CustomStringConvertible {
    private var megaBoard: MegaBoard
    private var visitCount: Int = 0
    private var winCount: Double = 0.0
    
    init(megaBoard: MegaBoard, visitCount: Int, winCount: Double) {
        self.megaBoard = megaBoard
        self.visitCount = visitCount
        self.winCount = winCount
    }
    
    init(megaBoard: MegaBoard) {
        self.megaBoard = megaBoard
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let megaBoardCopy = megaBoard.copy() as! MegaBoard
        let copy = GameState(megaBoard: megaBoardCopy, visitCount: visitCount, winCount: winCount)
        return copy
    }
    
    var description: String {
        var str = "GameState:\n"
        str += "Visit Count: \(visitCount), Win Count: \(winCount)\n"
        str += "\(megaBoard)\n"
        
        return str
    }
    
    public func getMegaBoard() -> MegaBoard {
        return self.megaBoard
    }
    
    public func setMegaBoard(_ megaBoard: MegaBoard) -> Void {
        self.megaBoard = megaBoard
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
    
    public func getAllPossibleStates() -> [GameState] {
        var result = [GameState]()
        for move in megaBoard.allPossibleMoves() {
            let newState = self.copy() as! GameState
            _ = newState.getMegaBoard().makeMove(boardNumber: move.boardNumber, index: move.index, winLocation: .none)
            result.append(newState)
        }
        return result
    }
    
    public func randomPlay() -> Void {
        let move = megaBoard.allPossibleMoves().randomElement()!
        _ = megaBoard.makeMove(boardNumber: move.boardNumber, index: move.index, winLocation: .none)
    }
}

class MCTSNode: NSCopying, CustomStringConvertible {
    private var state: GameState
    private var parent: MCTSNode?
    private var children: [MCTSNode]
    
    init(state: GameState, parent: MCTSNode?, children: [MCTSNode]) {
        self.state = state
        self.parent = parent
        self.children = children
    }
    
    init(gameState: GameState) {
        self.state = gameState
        children = [MCTSNode]()
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let stateCopy = state.copy() as! GameState
        let copy = MCTSNode(state: stateCopy, parent: parent, children: children)
        return copy
    }
    
    var description: String {
        var str = "MCTSNode:\n"
        str += "\(state)\n"
        str += "parent?: \(parent == nil ? "none" : "yes")\n"
        str += "Num children: \(children.count)\n"
        
        return str
    }
    
    public func getState() -> GameState {
        return self.state
    }
    
    public func getParent() -> MCTSNode? {
        return self.parent
    }
    
    public func setParent(_ parent: MCTSNode) -> Void {
        self.parent = parent
    }
    
    public func getChildren() -> [MCTSNode] {
        return self.children
    }
    
    public func addToChildren(_ child: MCTSNode) -> Void {
        children.append(child)
    }
    
    public func getRandomChild() -> MCTSNode {
        return children.randomElement()!
    }
    
    public func height() -> Int {
        var node = self
        var height = 0
        while node.getChildren().count != 0 {
            let children = node.getChildren()
            node = children[0]
            height += 1
        }
        return height
    }
}

class MCTSTreeSearch {
    var aiPlayer = Status.notFinished
    var opponent = Status.notFinished
    var depthTime: Double
    var root: MCTSNode?
    static var AIOptions = [(MegaBoard, Double)]()
    
    init(depthTime: Double) {
        self.depthTime = depthTime
    }
    
    public func findNextMove(megaBoard: MegaBoard) -> MegaBoard {
//        let start = DispatchTime.now()
        let THREADS = 2
        MCTSTreeSearch.AIOptions = [(MegaBoard, Double)]()
        let treeQueue = DispatchQueue(label: "tree.queue", attributes: .concurrent)
        let treeGroup = DispatchGroup()
        treeGroup.enter()
//        print(start.distance(to: DispatchTime.now()))
        
        for _ in 0 ..< THREADS {
            treeQueue.async {// [weak self] in
                self.findANextMove(megaBoard: megaBoard)
                if MCTSTreeSearch.AIOptions.count == THREADS {
                    treeGroup.leave()
                }
            }
        }
        var best = Double(Int.min)
        var bestBoard: MegaBoard?
        
        treeGroup.wait()
//        print(start.distance(to: DispatchTime.now()))
        for item in MCTSTreeSearch.AIOptions {
            if item.1 > best {
                best = item.1
                bestBoard = item.0
            }
        }
        print("Best Score: \(best)")
        return bestBoard ?? megaBoard
    }
    
    public func findANextMove(megaBoard: MegaBoard) -> Void {
        print("\nRunning for \(depthTime) seconds.")
        aiPlayer = megaBoard.XTurn ? .X : .O
        opponent = megaBoard.XTurn ? .O : .X
        let rootNode = MCTSNode(gameState: GameState(megaBoard: megaBoard)).copy() as! MCTSNode
        root = rootNode

        var count = 0
        let start = DispatchTime.now()
        let end = DispatchTime.now() + depthTime
        while (DispatchTime.now() < end) { // while time not up
            // got to most promising leaf
            let promisingNode = selectPromisingNode(rootNode)
            if promisingNode.getState().getMegaBoard().megaWinStatus == .notFinished {
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
        var bestNode: MCTSNode? //may ignore game over situations
                
        for (index, node) in rootNode.getChildren().enumerated() {
            let nodeScore = node.getState().getWinCount() / Double(node.getState().getVisitCount())
            print("Index: \(index), \(node.getState().getWinCount())/\(node.getState().getVisitCount()): gives \(nodeScore)")

            if nodeScore > max {
                max = nodeScore
                bestNode = node
            }
        }
        print(start.distance(to: DispatchTime.now()))
        print("Choice \(bestNode?.getState().getWinCount().description ?? "error")/\(bestNode?.getState().getVisitCount().description ?? "error"): gives \(max)")
        print("Simulated \(count) runs.")
        MCTSTreeSearch.AIOptions.append((bestNode?.getState().getMegaBoard() ?? megaBoard, max))

    }
    
    private func selectPromisingNode(_ rootNode: MCTSNode) -> MCTSNode {
        var node = rootNode
        while (node.getChildren().count != 0) {
            node = UCT.findBestNodeWithUCT(node: node)
        }
        return node
    }
    
    private func expandNode(_ node: MCTSNode) -> Void {
        let possibleStates: [GameState] = node.getState().getAllPossibleStates()
        for state in possibleStates {
            let newNode: MCTSNode = MCTSNode(gameState: state)
            newNode.setParent(node)
            node.addToChildren(newNode)
        }
    }
    
    private func simulateRandomPlayout(node: MCTSNode) -> Status {
        let tempNode = node.copy() as! MCTSNode
        let tempState = tempNode.getState()
        var boardStatus = tempNode.getState().getMegaBoard().megaWinStatus
        if boardStatus == opponent {
            node.getParent()!.getState().addToWinCount(Double(Int.min))
            print("Oppo")
            return boardStatus
        }
        while (boardStatus == .notFinished) {
            tempState.randomPlay()
            boardStatus = tempState.getMegaBoard().megaWinStatus
        }
        return boardStatus
    }
    
    private func backPropogation(node: MCTSNode, result: Status) -> Void {
        var tempNode: MCTSNode? = node
        while (tempNode != nil) {
            tempNode!.getState().incrementVisitCount()
            if (tempNode!.getState().getMegaBoard().XTurn ? .O : .X) == result { // swapped
                tempNode!.getState().addToWinCount(1.0)
            } else if result == .tie {
                tempNode!.getState().addToWinCount(0.5)
            }
            tempNode = tempNode!.getParent()
        }
    }
}
