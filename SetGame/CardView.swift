//
//  CardView.swift
//  Set
//
//  Created by yuzhongbao on 2023/4/5.
//

import SwiftUI

struct CardView: View {
    let card: GameViewModel.Card
    var isSelected: Bool = false
    
    private var symbolColor: Color {
        switch card.content.color {
        case .first:
            return .indigo
        case .secend:
            return .mint
        case .third:
            return .purple
        }
    }
    private var isMatched: Bool? {
        switch card.isMatched {
        case .matched:
            return true
        case .none:
            return nil
        case .notMatched:
            return false
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
//            ZStack {
                symbol(proxy: geometry)
//            }
            //自定义ViewModifier
                .cardify(isDealt: card.isDealt, isSelected: isSelected, isMatched: isMatched)
            
        }
    }
    
    private func symbol(proxy geometry: GeometryProxy) -> some View {
        Group {
            switch card.content.shape {
            case .diamond:
                VStack {
                    ForEach(0..<card.content.number.rawValue, id: \.self) { _ in
                        DrawShapeView(card: card, shape: Diamond(), color: symbolColor)
                            .frame(height: geometry.size.height / 5)
                    }
                }
            case .squiggle://波浪形不会画，暂时用圆角矩形替代
                VStack {
                    ForEach(0..<card.content.number.rawValue, id: \.self) { _ in
                        DrawShapeView(card: card, shape: RoundedRectangle(cornerRadius: DrawConstrant.cornerRadius), color: symbolColor)
                            .frame(height: geometry.size.height / 5)
                    }
                }
            case .oval:
                VStack {
                    ForEach(0..<card.content.number.rawValue, id: \.self) { _ in
                        DrawShapeView(card: card, shape: Ellipse(), color: symbolColor)
                            .frame(height: geometry.size.height / 5)
                    }
                }
            }
        }
        .frame(width: geometry.size.width * DrawConstrant.frameScale)
        .aspectRatio(DrawConstrant.aspectRatio, contentMode: .fit)
    }
    
//    private func strokedSymbol(shape: Shape) -> some View {
//
//    }
//
//    private func filledSymbol() -> some View {
//
//    }
//
//    private func shadedSymbol() -> some View {
//
//    }
    
//    private func font(in size: CGSize) -> Font {
//        Font.system(size: min(size.width, size.height) * 0.75)
//    }
    
    private struct DrawShapeView<ShapeType: Shape>: View {
        let card: GameViewModel.Card
        let shape: ShapeType
        let color: Color
        
        var body: some View {
            if card.content.shading == .solid {
                shape.fill().foregroundColor(color)
            }
            if card.content.shading == .open {
                shape.stroke(color, lineWidth: DrawConstrant.lineWidth)
            }
            if card.content.shading == .striped {//条纹也不会画，暂时用半透明替代
                shape.fill().foregroundColor(color).opacity(DrawConstrant.shapeOpacity)
            }
        }
    }
    
    private struct DrawConstrant {
        static let cornerRadius: CGFloat = 5
        static let lineWidth: CGFloat = 3
        static let aspectRatio: CGFloat = 5/3
        static let frameScale: CGFloat = 0.8
        static let shapeOpacity: CGFloat = 0.4
    }
}



















//struct CardView_Previews: PreviewProvider {
//    static var previews: some View {
//        CardView()
//    }
//}
