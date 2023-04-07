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
    private var matchedColor: Color {
        switch card.isMatched {
        case .matched:
            return .green
        case .none:
            return .blue
        case .notMatched:
            return .red
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                let shape = RoundedRectangle(cornerRadius: DrawConstrant.cornerRadius)
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(isSelected ? .orange : .blue.opacity(0.4), lineWidth: DrawConstrant.lineWidth)
                if card.isMatched != .none {
                    shape.strokeBorder(matchedColor, lineWidth: DrawConstrant.lineWidth + 2)
                }
                symbol(proxy: geometry)
            }
        }
    }
    
    private func symbol(proxy geometry: GeometryProxy) -> some View {
        Group {
            switch card.content.shape {
            case .diamond:
                VStack {
                    ForEach(0..<card.content.number.rawValue, id: \.self) { _ in
                        DrawShapeView(card: card, shape: Diamond(), color: symbolColor)
                    }
                }
            case .squiggle://波浪形不会画，暂时用圆角矩形替代
                VStack {
                    ForEach(0..<card.content.number.rawValue, id: \.self) { _ in
                        DrawShapeView(card: card, shape: RoundedRectangle(cornerRadius: DrawConstrant.cornerRadius), color: symbolColor)
                    }
                }
            case .oval:
                VStack {
                    ForEach(0..<card.content.number.rawValue, id: \.self) { _ in
                        DrawShapeView(card: card, shape: Ellipse(), color: symbolColor)
                    }
                }
            }
        }
        .frame(width: geometry.size.width * DrawConstrant.frameScale, height: geometry.size.height * DrawConstrant.frameScale)
//        .padding(10)
        .aspectRatio(5/3, contentMode: .fit)
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
    
    struct DrawShapeView<ShapeType: Shape>: View {
        let card: GameViewModel.Card
        let shape: ShapeType
        let color: Color
        
        var body: some View {
            if card.content.shading == .solid {
                shape.fill().foregroundColor(color)
            }
            if card.content.shading == .open {
                shape.stroke(color, lineWidth: 3)
            }
            if card.content.shading == .striped {//条纹也不会画，暂时用半透明替代
                shape.fill().foregroundColor(color).opacity(0.4)
            }
        }
    }
}

struct DrawConstrant {
    static let cornerRadius: CGFloat = 5
    static let lineWidth: CGFloat = 3
    static let aspectRatio: CGFloat = 2/3
    static let frameScale: CGFloat = 0.8
}



//struct CardView_Previews: PreviewProvider {
//    static var previews: some View {
//        CardView()
//    }
//}
