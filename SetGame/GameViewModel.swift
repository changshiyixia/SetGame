//
//  GameViewModel.swift
//  Set
//
//  Created by yuzhongbao on 2023/4/5.
//

import Foundation

class GameViewModel: ObservableObject {
    typealias Card = SetGame<Theme>.Card
    
    private static let themes = {
        var tempThemes: Array<Theme> = []
        for number in NumberOfPattern.allCases {
            for shape in ShapeOfPattern.allCases {
                for shading in ShadingOfPattern.allCases {
                    for color in ColorOfPattern.allCases {
                        tempThemes.append(Theme(number: number, shape: shape, shading: shading, color: color))
                    }
                }
            }
        }
        return tempThemes
    }()
    /**
     神奇形色牌的核心是组成Set的条件，只要桌面任意三张牌符合以下所有的条件，即为一个Set：
     1、三张牌的数字相同，或是三张牌的数字完全不同。
     2、三张牌的图案相同，或是三张牌的图案完全不同。
     3、三张牌的纹路相同，或是三张牌的纹路完全不同。
     4、三张牌的颜色相同，或是三张牌的颜色完全不同。
     */
    private static func isSet(selectedCards: Array<SetGame<Theme>.Card>) -> Bool? {
        guard selectedCards.count == 3 else { return nil }
        
        let numbers = Set(selectedCards.map { $0.content.number })
        let symbols = Set(selectedCards.map { $0.content.shape })
        let shadings = Set(selectedCards.map { $0.content.shading })
        let colors = Set(selectedCards.map { $0.content.color })
        return numbers.count != 2 || symbols.count != 2 || shadings.count != 2 || colors.count != 2
    }
    private static func createSetGame(with themes: Array<Theme>) -> SetGame<Theme> {
        SetGame(numberOfCardsShouldBeCreated: themes.count, createContent: { index in
            themes[index]
        }, isSet: isSet)
    }
    
    @Published var model = createSetGame(with: GameViewModel.themes)
    
    var cards: Array<Card> {
        model.cards
    }
    var cardsOnDesk: Array<Card> {
        model.cardsOnDesk
    }
    var cardsOfMatched: Array<Card> {
        model.cardsOfMatched
    }
    var countOfRemainingCard: Int {
        model.countOfRemainingCard
    }
    var allCardDealt: Bool {
        model.countOfRemainingCard < 1
    }
    
    func isSelected(_ card: Card) -> Bool {
        model.isSelected(card)
    }
    
    //MARK: - 对模型的操作
    func desktopInitial() {
        model.dealCards(12)
    }
    
    func choose(_ card: Card) {
        model.choose(card)
    }
    
    func dealCards(_ numberOfDeal: Int) {
        model.dealCards(numberOfDeal)
    }
    
    func restart() {
        model = GameViewModel.createSetGame(with: GameViewModel.themes)
        desktopInitial()
    }
}
