//
//  ColorButton.swift
//  MegaTicTacToe
//
//  Created by Jules Walzer-Goldfeld on 6/23/20.
//  Copyright © 2020 Jules Walzer-Goldfeld. All rights reserved.
//

import SwiftUI

struct ColorButton: View {
    @Binding var modelColor: Color
    var frameSize: CGFloat
    var color: Color
    
    var opaque: Double {
        get {
            return self.modelColor == self.color ? 1.0 : 0.0
        }
    }
    
    func updateColor() -> Void {
        self.modelColor = self.color
    }
    
    var body: some View {
        Button(action: updateColor ) {
            Circle()
                .foregroundColor(self.color)
                .frame(maxWidth: frameSize, maxHeight: frameSize)
                .overlay(Circle()
                    .stroke(Color.primary, lineWidth: 3)
                    .opacity(opaque)
                )
        }
    }
}
