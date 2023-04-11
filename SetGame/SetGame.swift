//
//  SetGame.swift
//  Set
//
//  Created by yuzhongbao on 2023/4/5.
//

import Foundation

struct SetGame<CardContent> {
    //所有的卡牌
    private(set) var cards: Array<Card>
    //桌上的牌
    private(set) var cardsOnDesk: Array<Card> {
        willSet {
//            newValue.forEach({ card in
//                card.isMatched = .none
//            })
        }
    }
    //已匹配的牌堆
    private(set) var cardsOfMatched: Array<Card>
    //已选择卡牌的索引集合
    private var indicesOfSelectedCard: Set<Int>
    //给定卡牌是否匹配一个set
    private var isSet: (Array<Card>) -> Bool?
    //已选择的卡牌是否匹配
    private var isMatched: Bool? {
        guard indicesOfSelectedCard.count == 3 else { return nil }
        
        var tempIndices = indicesOfSelectedCard
        var selectedCards = Array<Card>()
        for _ in tempIndices {
            selectedCards.append(cardsOnDesk[tempIndices.removeFirst()])
        }
        if let match = isSet(selectedCards) {
            return match
        } else {
            return nil
        }
    }
    
    //剩余未发到桌上的牌数
    var countOfRemainingCard: Int {
        cards.filter({ $0.isDealt == false }).count
    }
    
    init(numberOfCardsShouldBeCreated: Int ,createContent: (Int) -> CardContent, isSet: @escaping (Array<Card>) -> Bool?) {
        self.cards = []
        self.cardsOnDesk = []
        self.cardsOfMatched = []
        self.indicesOfSelectedCard = []
        self.isSet = isSet
        for index in 0..<numberOfCardsShouldBeCreated {
            cards.append(Card(content: createContent(index), id: index))
        }
        cards.shuffle()
    }
    
    //MARK: private
    private mutating func repalceTheMatchedCards() {
        for index in indicesOfSelectedCard.sorted(by: { $0 > $1 }) {
            if let undealIndex = cards.firstIndex(where: { $0.isDealt == false }) {
                //匹配的卡牌重置为无状态，消除匹配显示效果
                var matchedCard = cardsOnDesk[index]
                matchedCard.isMatched = .none
                cardsOfMatched.append(matchedCard)
                
                cards[undealIndex].isDealt = true
                cardsOnDesk[index] = cards[undealIndex]
            }
        }
    }
    
    private mutating func deal(_ numberOfDeal: Int) {
        for _ in 1...numberOfDeal {
            if let undealIndex = cards.firstIndex(where: { $0.isDealt == false }) {
                cards[undealIndex].isDealt = true
                cardsOnDesk.append(cards[undealIndex])
            }
        }
    }
    
    //MARK: to viewModel
    mutating func choose(_ card: Card) {
        if let chosenIndex = cardsOnDesk.firstIndex(where: { $0.id == card.id }) {
            if indicesOfSelectedCard.count < 3 {
                //集合新增,若失败则是已选择，反选之
                if !indicesOfSelectedCard.insert(chosenIndex).inserted {
                    indicesOfSelectedCard.remove(chosenIndex)
                }
                if indicesOfSelectedCard.count == 3, let isMatched = isMatched {
                    indicesOfSelectedCard.forEach({
                        cardsOnDesk[$0].isMatched = (isMatched ? .matched : .notMatched)
                    })
                }
            } else if indicesOfSelectedCard.count == 3 {
                //不可再次选择已匹配的卡片
                if indicesOfSelectedCard.contains(chosenIndex), isMatched! {
                    return
                }
                //添加到匹配牌堆
                if isMatched! {
                    indicesOfSelectedCard.sorted(by: { $0 > $1 }).forEach({
                        var matchedCard = cardsOnDesk.remove(at: $0)
                        matchedCard.isMatched = .none
                        cardsOfMatched.append(matchedCard)
                    })
                } else {
                    indicesOfSelectedCard.forEach({ cardsOnDesk[$0].isMatched = .none })
                }
                indicesOfSelectedCard = []
                //如果选择的卡片在已匹配的三张卡片中间或后面，必须重新获取索引，因为此时已匹配的卡片已从桌面上移除。
                if let index = cardsOnDesk.firstIndex(where: { $0.id == card.id }) {
                    indicesOfSelectedCard.insert(index)
                }
            }
        }
    }
    /**
     按规则发放指定数量的卡片到桌面上：
     1、如选中的卡片匹配，替换之并清空已选择状态；若已选中的卡片未匹配，从牌堆中抽出指定数量未发到桌面的卡片添加到桌面上卡片后面
     2、已选择卡片不足三张，直接从牌堆中抽出指定数量未发到桌面的卡片添加到桌面上卡片后面
     */
    mutating func dealCards(_ numberOfDeal: Int) {
        if let isMatched = isMatched {
            if isMatched {
                repalceTheMatchedCards()
                indicesOfSelectedCard = []
            } else {
                deal(numberOfDeal)
            }
        } else {
            deal(numberOfDeal)
        }
    }

    //判断当前卡片是否已被选中
    func isSelected(_ card: Card) -> Bool {
        if let chosenIndex = cardsOnDesk.firstIndex(where: { $0.id == card.id }) {
            return indicesOfSelectedCard.contains(chosenIndex)
        } else {
            return false
        }
    }
    
    struct Card: Identifiable {
        //是否已发到桌面
        var isDealt: Bool = false
        //是否匹配三张卡片
        var isMatched: MatchStatus = .none
        //内容由主题决定
        var content: CardContent
        //唯一键值
        var id: Int
    }
    
    enum MatchStatus {
        //匹配
        case matched
        //无状态
        case none
        //不匹配
        case notMatched
    }
}
