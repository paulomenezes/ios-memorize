//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Paulo Menezes on 08/06/21.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    typealias Card = MemoryGame<String, Color>.Card
    
    private static let emojis = [
        ["đ", "đ", "đ", "đ", "đ", "đī¸", "đ", "đ", "đ", "đ"],
        ["đļ", "đą", "đ­", "đš", "đ°", "đĻ", "đģ", "đŧ"],
        ["đ", "đ", "đ", "đ", "đ", "đ", "đ", "đ"],
        ["đģ", "đ", "đ", "đ", "đĩ", "đī¸", "đ˛", "đ´"],
        ["đĻŧ", "đĻŊ", "đĻ¯", "đē", "đ", "đ", "đ", "đ"],
        ["đĄ", "đ ", "đ", "đ", "đ", "đ", "đ", "đ"],
        ["đ", "đ", "đ", "đ", "đ", "đ", "đ", "âī¸"],
        ["đĢ", "đŦ", "đŠī¸", "đē", "đ°ī¸", "đ", "đ¸", "đ"]
    ]

    private static func createMemoryGame() -> MemoryGame<String, Color> {
        var themes: [MemoryGame<String, Color>.Theme] = []
        
        themes.append(MemoryGame<String, Color>.Theme(name: "Vehicles", contents: emojis[0], color: .red))
        themes.append(MemoryGame<String, Color>.Theme(name: "Animals", contents: emojis[1], color: .blue, random: true))
        themes.append(MemoryGame<String, Color>.Theme(name: "Fruits", contents: emojis[2], numberOfPairsToShow: 4, color: .orange))
        
        return MemoryGame<String, Color>(themes: themes)
    }
    
    @Published private var model: MemoryGame<String, Color> = createMemoryGame()
    
    var cards: Array<Card> {
        model.cards
    }
    
    var theme: MemoryGame<String, Color>.Theme {
        model.themes[model.selectedTheme]
    }
    
    var score: Int {
        model.score
    }
    
    // MARK: - Intent(s)
    
    func choose(_ card: Card) {
        model.choose(card)
    }
    
    func newGame() {
         model.newGame()
    }
    
    func shuffle() {
        model.shuffle()
    }
}
