//
//  Cardify.swift
//  SetGame
//
//  Created by yuzhongbao on 2023/4/9.
//

import SwiftUI

struct Cardify: ViewModifier {
    var isDealt: Bool
    var isSelected: Bool
    var isMatched: Bool?
    
    private var matchedColor: Color {
        switch isMatched {
        case true:
            return .green
        case false:
            return .red
        default:
            return .blue
        }
    }
    
    func body(content: Content) -> some View {
//        let gradient = LinearGradient(
//            gradient: Gradient(colors: [Color.yellow, Color.red]),
//            startPoint: .topLeading,
//            endPoint: .bottomTrailing
//        )

        ZStack {
            let shape = RoundedRectangle(cornerRadius: DrawConstrant.cornerRadius)
            if isDealt {
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(isSelected ? .orange : .blue.opacity(0.4), lineWidth: DrawConstrant.lineWidth)
                if isMatched != nil {
                    shape.strokeBorder(matchedColor, lineWidth: DrawConstrant.lineWidth + 2)
                }
                content
            } else {
                shape.fill()
            }
        }
    }
    
    private struct DrawConstrant {
        static let cornerRadius: CGFloat = 5
        static let lineWidth: CGFloat = 3
        static let aspectRatio: CGFloat = 2/3
    }
}

extension View {
    func cardify(isDealt: Bool, isSelected: Bool, isMatched: Bool?) -> some View {
        return self.modifier(Cardify(isDealt: isDealt, isSelected: isSelected, isMatched: isMatched))
    }
}

extension UIView {
  func animateBorderColor(toColor: UIColor, duration: Double) {
    let animation = CABasicAnimation(keyPath: "borderColor")
    animation.fromValue = layer.borderColor
    animation.toValue = toColor.cgColor
    animation.duration = duration
    layer.add(animation, forKey: "borderColor")
    layer.borderColor = toColor.cgColor
  }
}
