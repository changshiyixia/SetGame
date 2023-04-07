//
//  SetGameView.swift
//  Set
//
//  Created by yuzhongbao on 2023/4/5.
//

import SwiftUI

struct SetGameView: View {
    @ObservedObject var game: GameViewModel
//    @State private var viewId = 0
    
    var body: some View {
        VStack {
            AspectVGrid(items: game.cards, aspectRatio: 2/3, content: { card in
                CardView(card: card, isSelected: game.isSelected(card))
                    .padding(1)
                    .onTapGesture {
                        game.choose(card)
                    }
            })
            .foregroundColor(.blue)
            .padding(.horizontal)
//            .id(viewId)
            HStack(alignment: .bottom) {
                Spacer()
                Button("开始新游戏", action: { game.newGame() })
                    .font(.title)
                    .buttonStyle(.bordered)
                    .buttonBorderShape(.roundedRectangle)
                Spacer()
                Button("发三张牌", action: {
                    game.dealCards()
//                    DispatchQueue.main.async {
//                        self.viewId += 1
//                    }
                })
                .font(.title)
                .buttonStyle(.bordered)
                .buttonBorderShape(.roundedRectangle)
                .disabled(game.isAllCardsDealed())
                Spacer()
            }
//            .edgesIgnoringSafeArea(.bottom)
            .padding(.bottom, -15.0)
            
        }
    }
}

































struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = GameViewModel()
        
        SetGameView(game: game)
            .preferredColorScheme(.dark)
        SetGameView(game: game)
    }
}
