//
//  SetGameView.swift
//  Set
//
//  Created by yuzhongbao on 2023/4/5.
//

import SwiftUI

struct SetGameView: View {
    @ObservedObject var game: GameViewModel
    
    @Namespace private var dealingNamespace
    
    var body: some View {
        ZStack(alignment: .bottom) {
            gameBody
            HStack {
                discardPile
                Button("开始新游戏", action: {
                    withAnimation(.easeInOut(duration: CardConstants.dealDuration)) {
                        game.restart()
                    }
                })
                    .font(.title2)
                    .buttonStyle(.bordered)
                    .buttonBorderShape(.roundedRectangle)
                    .frame(maxWidth: .infinity)
                deckBody
            }
            .frame(height: 30)
            .padding(.horizontal, 40)
            .padding(.bottom, -15.0)
        }
    }
   
//    @State private var dealt = Set<Int>()
//
//    private func deal(_ card: GameViewModel.Card) {
//        dealt.insert(card.id)
//    }
//
//    private func isUndealt(_ card: GameViewModel.Card) -> Bool {
//        !dealt.contains(card.id)
//    }
//    private func dealAnimation(for card: GameViewModel.Card) -> Animation {
//        var delay = 0.0
//        if let index = game.cardsOnDesk.firstIndex(where: { $0.id == card.id}) {
//            delay = Double(index) * (CardConstants.totalDealDuration / Double(game.cardsOnDesk.count))
//        }
//        return Animation.easeInOut(duration: CardConstants.dealDuration).delay(delay)
//    }
    
    var gameBody: some View {
        AspectVGrid(
            items: game.cardsOnDesk,
            aspectRatio: CardConstants.aspectRatio, content: { card in
                CardView(card: card, isSelected: game.isSelected(card))
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .padding(1)
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: CardConstants.dealDuration)) {
                            game.choose(card)
                        }
                    }
                
            })
        .foregroundColor(CardConstants.color)
        .padding(.horizontal)
        .onAppear {
            withAnimation(.easeInOut(duration: CardConstants.dealDuration)) {
                game.dealCards(12)
            }
        }
    }
    
    var discardPile: some View {
        ZStack {
            ForEach(game.cardsOfMatched) { card in
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
            }
        }
        .frame(width: CardConstants.dealWidth, height: CardConstants.dealHeight)
        .foregroundColor(CardConstants.color)
        .rotationEffect(Angle(degrees: 90))
    }
    
    private func zIndex(of card: GameViewModel.Card) -> Double {
        -Double(game.cards.firstIndex(where: { $0.id == card.id }) ?? 0)
    }
    
    var deckBody: some View {
        ZStack {
            ForEach(game.cards.filter({ $0.isDealt == false })) { card in
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .zIndex(zIndex(of: card))
            }
        }
        .frame(width: CardConstants.dealWidth, height: CardConstants.dealHeight)
        .foregroundColor(CardConstants.color)
        .rotationEffect(Angle(degrees: 90))
        .onTapGesture {
            withAnimation(.easeInOut(duration: CardConstants.dealDuration)) {
                game.dealCards(3)
            }
        }
    }
    
//    private func font(in size: CGSize) -> Font {
//        Font.system(size: min(size.width, size.height) * 0.75)
//    }
    
    private struct CardConstants {
        static let color = Color.blue
        static let aspectRatio: CGFloat = 2/3
        static let dealHeight: CGFloat = 60
        static let dealWidth: CGFloat = dealHeight * aspectRatio
        static let dealDuration: Double = 0.5
    }
}

































struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = GameViewModel()
        
        SetGameView(game: game)
            .preferredColorScheme(.dark)
//        SetGameView(game: game)
    }
}
