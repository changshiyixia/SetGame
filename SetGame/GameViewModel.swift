//
//  GameViewModel.swift
//  Set
//
//  Created by yuzhongbao on 2023/4/5.
//

import Foundation

class GameViewModel: ObservableObject {
    typealias Card = SetGame<ThemeOfSetGame>.Card
    
    static let themes = {
        var tempThemes: Array<ThemeOfSetGame> = []
        for number in NumberOfPattern.allCases {
            for shape in ShapeOfPattern.allCases {
                for shading in ShadingOfPattern.allCases {
                    for color in ColorOfPattern.allCases {
                        tempThemes.append(ThemeOfSetGame(number: number, shape: shape, shading: shading, color: color))
                    }
                }
            }
        }
        return tempThemes
    }()
    
    static func createSetGame(with themes: Array<ThemeOfSetGame>) -> SetGame<ThemeOfSetGame> {
        SetGame(numberOfCardsShouldBeCreated: themes.count, createContent: { index in
            themes[index]
        })
    }
    
    @Published var model = createSetGame(with: GameViewModel.themes)
     
    var cards: Array<Card> {
        return model.cardsOnDesk
    }
    
    init() {
        desktopInitial()
    }
    
    //MARK: - intent(s)
    private func desktopInitial() {
        model.dealCards(12)
    }
    
    func choose(_ card: Card) {
        model.choose(card)
    }
    
    func dealCards() {
        model.dealCards(3)
    }
    
    func newGame() {
        model = GameViewModel.createSetGame(with: GameViewModel.themes)
        desktopInitial()
    }
    
    func isAllCardsDealed() -> Bool {
        model.allCardsDealed
    }

    func isSelected(_ card: Card) -> Bool {
        model.isSelected(card)
    }
}

/**
 此协议是为了在SetGame模型中使用泛型CardContent的实例属性。暂时没想到更好的办法。
 */
protocol Content {
    var number: NumberOfPattern { get }
    var shape: ShapeOfPattern { get }
    var shading: ShadingOfPattern { get }
    var color: ColorOfPattern { get }
}


