//
//  BitMCTSNode.swift
//  MegaTicTacToe
//
//  Created by Jules Walzer-Goldfeld on 6/27/20.
//  Copyright © 2020 Jules Walzer-Goldfeld. All rights reserved.
//

import Foundation

class BitMCTSNode: NSCopying, CustomStringConvertible {
    private var state: BitState
    private var parent: BitMCTSNode?
    private var children: [BitMCTSNode]
    
    init(state: BitState, parent: BitMCTSNode?, children: [BitMCTSNode]) {
        self.state = state
        self.parent = parent
        self.children = children
    }
    
    init(bitState: BitState) {
        self.state = bitState
        children = [BitMCTSNode]()
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let stateCopy = state.copy() as! BitState
        let copy = BitMCTSNode(state: stateCopy, parent: parent, children: children)
        return copy
    }
    
    var description: String {
        var str = "BitMCTSNode:\n"
        str += "\(state)\n"
        str += "parent?: \(parent == nil ? "none" : "yes")\n"
        str += "Num children: \(children.count)\n"
        
        return str
    }
    
    public func getState() -> BitState {
        return self.state
    }
    
    public func getParent() -> BitMCTSNode? {
        return self.parent
    }
    
    public func setParent(_ parent: BitMCTSNode) -> Void {
        self.parent = parent
    }
    
    public func getChildren() -> [BitMCTSNode] {
        return self.children
    }
    
    public func addToChildren(_ child: BitMCTSNode) -> Void {
        children.append(child)
    }
    
    public func getRandomChild() -> BitMCTSNode {
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
