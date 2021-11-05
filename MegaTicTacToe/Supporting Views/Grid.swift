//
//  Grid.swift
//  MegaTicTacToe
//
//  Created by Jules Walzer-Goldfeld on 6/22/20.
//  Copyright © 2020 Jules Walzer-Goldfeld. All rights reserved.
//

import SwiftUI

struct GridView<Content: View>: View {
    let content: (Int, Int) -> Content
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            ForEach(0 ..< 3, id: \.self) { row in
                HStack(alignment: .center, spacing: 0 ) {
                    ForEach(0 ..< 3, id: \.self) { col in
                        self.content(row, col)
                    }
                }
            }
        }
    }
}
