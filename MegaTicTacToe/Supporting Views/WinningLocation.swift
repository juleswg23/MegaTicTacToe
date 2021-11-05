//
//  WinningLocation.swift
//  MegaTicTacToe
//
//  Created by Jules Walzer-Goldfeld on 6/23/20.
//  Copyright © 2020 Jules Walzer-Goldfeld. All rights reserved.
//

import Foundation

enum WinningLocation {
    case vLeft, vMid, vRight
    case hTop, hMid, hBot
    case tLeft, tRight
    case none
    
    func coef() -> [Double] {
        switch self {
        case .vLeft: return [1/6, 1/24, 1/6, 23/24]
        case .vMid: return [1/2, 1/24, 1/2, 23/24]
        case .vRight: return [5/6, 1/24, 5/6, 23/24]
        
        case .hTop: return [1/24, 1/6, 23/24, 1/6]
        case .hMid: return [1/24, 1/2, 23/24, 1/2]
        case .hBot: return [1/24, 5/6, 23/24, 5/6]
        
        case .tLeft: return [1/12, 1/12, 11/12, 11/12]
        case .tRight: return [1/12, 11/12, 11/12, 1/12]
        case .none: return [0, 0, 0, 0]
        }
    }
}
