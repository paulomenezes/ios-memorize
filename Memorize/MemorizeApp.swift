//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Paulo Menezes on 08/06/21.
//

import SwiftUI

@main
struct MemorizeApp: App {
    private let game = EmojiMemoryGame()
    
    var body: some Scene {
        WindowGroup {
            EmojiMemoryGameView(game: game)
        }
    }
}
