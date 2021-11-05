//
//  Content.swift
//  TicTacToe
//
//  Created by Jules Walzer-Goldfeld on 6/13/20.
//  Copyright © 2020 Jules Walzer-Goldfeld. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State var depthTime: Double = 2.5
    @ObservedObject var model = MegaModel()
    
    var body: some View {
        GeometryReader { geo in
            VStack (alignment: .center) {
                MegaView(width: min(geo.size.width, geo.size.height), model: self.model)
                    .padding(.vertical, geo.size.height/15)
                HStack (spacing: 30) {
                    Button(action: {
                        self.model.playAIMove(depthTime: self.depthTime)
                        self.model.didUpdate.toggle()
                    }) {
                        Text("Play AI Move")
                        .font(.system(size: 22))
                        .fontWeight(.medium)
                        .padding(.all, 12)
                        .background(Capsule().stroke(lineWidth: 4))
                        .foregroundColor(ColorManager.primary)
                    }
                    
                    Button(action: {
                        self.model.newGame()
                    }) {
                       Text("New Game")
                        .font(.system(size: 22))
                        .fontWeight(.medium)
                        .padding(.all, 12)
                        .background(Capsule().stroke(lineWidth: 4))
                        .foregroundColor(ColorManager.primary)
                    }
                    .padding(.vertical, geo.size.height/30)
                }
                
                HStack(spacing: geo.size.width/38) {
                    Group {
                        Spacer()
                        
                        ColorButton(modelColor: self.$model.XColor, frameSize: geo.size.width/12, color: ColorManager.user1)
                        ColorButton(modelColor: self.$model.XColor, frameSize: geo.size.width/12, color: ColorManager.user2)
                        ColorButton(modelColor: self.$model.XColor, frameSize: geo.size.width/12, color: ColorManager.user3)
                    
                        Spacer()
                    }

                    ColorButton(modelColor: self.$model.OColor, frameSize: geo.size.width/12, color: ColorManager.user3)
                    ColorButton(modelColor: self.$model.OColor, frameSize: geo.size.width/12, color: ColorManager.user2)
                    ColorButton(modelColor: self.$model.OColor, frameSize: geo.size.width/12, color: ColorManager.user1)
                    
                    Spacer()
                    
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
