//
//  MemoryGame.swift
//  Memorize
//
//  Created by Paulo Menezes on 08/06/21.
//

import Foundation

extension Array {
    var oneAndOnly: Element? {
        if count == 1 { return first }
        
        return nil
    }
}

struct MemoryGame<CardContent, ColorType> where CardContent: Equatable {
    private(set) var cards: [Card] = []
    private(set) var themes: [Theme]
    private(set) var selectedTheme = 0
    private(set) var score = 0

    private var indexOfTheOneAndOnlyCardFaceUp: Int? {
        get { cards.indices.filter { i in cards[i].isFaceUp }.oneAndOnly }
        set { cards.indices.forEach { index in cards[index].isFaceUp = index == newValue } }
    }
    private var dateOfLastFaceUp: Date?
    
    init(themes: [Theme]) {
        self.themes = themes
        
        newGame()
    }
    
    mutating func newGame() {
        let themeIndex = Int.random(in: 0..<themes.count)
        
        initialize(themeIndex: themeIndex)
    }
    
    mutating func initialize(themeIndex: Int) {
        score = 0
        selectedTheme = themeIndex
        dateOfLastFaceUp = nil
        
        cards.removeAll()
        
        let shuffledContent = themes[themeIndex].contents.shuffled()
        
        let size = min(themes[themeIndex].contents.count - 1, themes[themeIndex].numberOfPairsToShow)
        
        for pairIndex in 0..<size {
            cards.append(Card(content: shuffledContent[pairIndex], id: 10 * themeIndex + pairIndex * 2))
            cards.append(Card(content: shuffledContent[pairIndex], id: 10 * themeIndex + pairIndex * 2 + 1))
        }
        
        cards = cards.shuffled()
    }
    
    mutating func choose(_ card: Card) {
        if let chosenIndex = cards.firstIndex(where: { c in c.id == card.id }),
           !cards[chosenIndex].isFaceUp,
           !cards[chosenIndex].isMatched
        {
            if let potentialMatchIndex = indexOfTheOneAndOnlyCardFaceUp {
                let elapsed = Int(Date().timeIntervalSince(dateOfLastFaceUp!))
                
                if cards[chosenIndex].content == cards[potentialMatchIndex].content {
                    cards[chosenIndex].isMatched = true
                    cards[potentialMatchIndex].isMatched = true
                    
                    score += 2 * max(10 - elapsed, 1)
                } else {
                    score -= 1 * max(10 - elapsed, 1)
                }
                
                dateOfLastFaceUp = nil
                
            } else {
                indexOfTheOneAndOnlyCardFaceUp = chosenIndex
                dateOfLastFaceUp = Date()
            }
            
            cards[chosenIndex].isFaceUp = true
        }
    }
    
    mutating func shuffle() {
        cards.shuffle()
    }
    
    struct Card: Identifiable {
        var isFaceUp: Bool = false
        var isMatched: Bool = false
        let content: CardContent
        let id: Int
    }
    
    struct Theme {
        var name: String
        var contents: [CardContent]
        var numberOfPairsToShow: Int
        var color: ColorType
        
        init(name: String, contents: [CardContent], color: ColorType) {
            self.name = name
            self.contents = contents
            self.numberOfPairsToShow = contents.count - 1
            self.color = color
        }
        
        init(name: String, contents: [CardContent], color: ColorType, random: Bool) {
            self.name = name
            self.contents = contents
            self.numberOfPairsToShow = random ? Int.random(in: 4..<contents.count - 1) : contents.count - 1
            self.color = color
        }
        
        init(name: String, contents: [CardContent], numberOfPairsToShow: Int, color: ColorType) {
            self.name = name
            self.contents = contents
            self.numberOfPairsToShow = numberOfPairsToShow
            self.color = color
        }
    }
}
