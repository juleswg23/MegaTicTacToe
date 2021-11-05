//
//  ColorManager.swift
//  MegaTicTacToe
//
//  Created by Jules Walzer-Goldfeld on 6/23/20.
//  Copyright © 2020 Jules Walzer-Goldfeld. All rights reserved.
//

import SwiftUI

struct ColorManager {
    static let primary = Color(UIColor(named: "PrimaryColor") ?? .systemGray3)
    static let secondary = Color(UIColor(named: "SecondaryColor") ?? .systemGray)
    static let win = Color(UIColor(named: "Win") ?? .systemBlue)
    static let user1 = Color(UIColor(named: "User1") ?? .systemGreen)
    static let user2 = Color(UIColor(named: "User2") ?? .systemRed)
    static let user3 = Color(UIColor(named: "User3") ?? .systemOrange)
}
