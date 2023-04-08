//
//  SetGame.swift
//  Set
//
//  Created by yuzhongbao on 2023/4/5.
//

import Foundation

struct SetGame<CardContent: Content> {
    //所有的卡牌
    private(set) var cards: Array<Card>
    //已选择卡牌的序号集合
    private var indicesOfSelectedCard: Set<Int>
    /**
     神奇形色牌的核心是组成Set的条件，只要桌面任意三张牌符合以下所有的条件，即为一个Set：
     1、三张牌的数字相同，或是三张牌的数字完全不同。
     2、三张牌的图案相同，或是三张牌的图案完全不同。
     3、三张牌的纹路相同，或是三张牌的纹路完全不同。
     4、三张牌的颜色相同，或是三张牌的颜色完全不同。
     */
    private var isMatchedOfSelectedCards: Bool? {
        if indicesOfSelectedCard.count == 3 {
            var tempIndices = indicesOfSelectedCard
            var selectedCards = Array<Card>()
            for _ in indicesOfSelectedCard {
                selectedCards.append(cards[tempIndices.removeFirst()])
            }
            
            let numbers = Set(selectedCards.map { $0.content.number })
            let symbols = Set(selectedCards.map { $0.content.shape })
            let shadings = Set(selectedCards.map { $0.content.shading })
            let colors = Set(selectedCards.map { $0.content.color })
            return numbers.count != 2 || symbols.count != 2 || shadings.count != 2 || colors.count != 2
        } else {
            return nil
        }
    }
    //剩余未发到桌上的牌数
    var countOfRemainingCard: Int {
        cards.filter({ $0.isDealed == false }).count
    }
    
    init(numberOfCardsShouldBeCreated: Int ,createContent: (Int) -> CardContent) {
        self.cards = []
        self.indicesOfSelectedCard = []
        for index in 0..<numberOfCardsShouldBeCreated {
            cards.append(Card(content: createContent(index), id: index))
        }
        cards.shuffle()
    }
    
    mutating func choose(_ card: Card) {
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id }) {
            if indicesOfSelectedCard.count < 3 {
                //集合新增,若失败则是已选择，反选之
                if !indicesOfSelectedCard.insert(chosenIndex).inserted {
                    indicesOfSelectedCard.remove(chosenIndex)
                }
                if indicesOfSelectedCard.count == 3, let isMatched = isMatchedOfSelectedCards {
                    indicesOfSelectedCard.forEach({ cards[$0].isMatched = (isMatched ? .matched : .notMatched) })
                }
            } else if indicesOfSelectedCard.count == 3 {
                //不可再次选择已匹配的卡片
                if indicesOfSelectedCard.contains(chosenIndex), isMatchedOfSelectedCards! {
                    return
                }
                indicesOfSelectedCard.forEach({ cards[$0].isMatched = .none })
                //匹配则替换已匹配的三张牌
                if isMatchedOfSelectedCards! {
                    matchedAndRepalce()
                }
                indicesOfSelectedCard = []
                //如果当前所有卡牌都已发出，且选择的卡片在已匹配的三张卡片中间或后面，必须重新获取索引，因为此时已匹配的卡片已从桌面上移除。
                if countOfRemainingCard == 0, let index = cards.firstIndex(where: { $0.id == card.id }) {
                    indicesOfSelectedCard.insert(index)
                } else {
                    indicesOfSelectedCard.insert(chosenIndex)
                }
            }
        }
    }
    
    /**
     选择的三张卡片如果匹配，则另发三张牌替换这三张牌所在的位置；若所有牌都已发出，则移除已匹配的三张牌，此时后面的牌应顺次前移。
     注意：移除卡片后，可能会导致后面的卡片索引重排，所以需要重新定位
     */
    private mutating func matchedAndRepalce() {
        let idOfSelectedCard = indicesOfSelectedCard.map({ cards[$0].id })
        for cardId in idOfSelectedCard {
            //重新定位卡片索引
            if let index = cards.firstIndex(where: { $0.id == cardId }) {
                if let undealIndex = cards.firstIndex(where: { $0.isDealed == false }) {
                    cards[undealIndex].isDealed = true
                    cards.swapAt(index, undealIndex)
                    //交换后移除匹配卡片
                    cards.remove(at: undealIndex)
                } else {
                    if cards.count > 3 {
                        cards.remove(at: index)
                    }
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
        if let isMatched = isMatchedOfSelectedCards {
            if isMatched {
                matchedAndRepalce()
                indicesOfSelectedCard = []
            } else {
                for _ in 1...numberOfDeal {
                    if let undealIndex = cards.firstIndex(where: { $0.isDealed == false }) {
                        cards[undealIndex].isDealed = true
                    }
                }
            }
        } else {
            for _ in 1...numberOfDeal {
                if let undealIndex = cards.firstIndex(where: { $0.isDealed == false }) {
                    cards[undealIndex].isDealed = true
                }
            }
        }
    }

    //判断当前卡片是否已被选中
    func isSelected(_ card: Card) -> Bool {
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id }) {
            return indicesOfSelectedCard.contains(chosenIndex)
        } else {
            return false
        }
    }
    
    struct Card: Identifiable {
        //是否已发到桌面
        var isDealed: Bool = false
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
