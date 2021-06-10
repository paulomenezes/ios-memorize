//
//  ContentView.swift
//  Memorize
//
//  Created by Paulo Menezes on 08/06/21.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var game: EmojiMemoryGame

    @State private var dealt = Set<Int>()
    
    @Namespace private var dealingNamespace
    
    private func deal(_ card: EmojiMemoryGame.Card) {
        dealt.insert(card.id)
    }
    
    private func isUndealt(_ card: EmojiMemoryGame.Card) -> Bool {
        return !dealt.contains(card.id)
    }
    
    private func dealAnimation(for card: EmojiMemoryGame.Card) -> Animation {
        var delay = 0.0
        if let index = game.cards.firstIndex(where: { c in c.id == card.id }) {
            delay = Double(index) * (2 / Double(game.cards.count)) // totaldealdur
        }
        
        return Animation.easeOut(duration: 0.5).delay(delay) //dealdur
    }
    
    private func zIndex(of card: EmojiMemoryGame.Card) -> Double {
        -Double(game.cards.firstIndex(where: { c in c.id == card.id }) ?? 0)
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                Text("Memorize!").font(.largeTitle)
                AspectVGrid(items: game.cards, aspectRatio: 2/3) { card in
                    if isUndealt(card) || (card.isMatched && !card.isFaceUp) {
                        Color.clear
                    } else {
                        CardView(card: card)
                            .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                            .transition(AnyTransition.asymmetric(insertion: .identity, removal: .scale))
                            .zIndex(zIndex(of: card))
                            .foregroundColor(game.theme.color)
                            .onTapGesture {
                                withAnimation(.easeInOut) {
                                    game.choose(card)
                                }
                            }
                    }
                }
                HStack {
                    Button("New game") {
                        withAnimation {
                            dealt.removeAll()
                            game.newGame()
                        }
                    }
                    Button("Shuffle") {
                        withAnimation {
                            game.shuffle()
                        }
                    }
                    Spacer()
                    Text("\(game.theme.name) - Score: \(game.score)")
                }
            }
            deckBody
        }
        .padding(.horizontal)
    }
    
    var deckBody: some View {
        ZStack {
            ForEach(game.cards.filter(isUndealt)) { card in
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(AnyTransition.asymmetric(insertion: .opacity, removal: .identity))
                    .zIndex(zIndex(of: card))
            }
        }
        .frame(width: 90 * (2/3), height: 90)
        .foregroundColor(game.theme.color)
        .onTapGesture {
            for card in game.cards {
                withAnimation(dealAnimation(for: card)) {
                    deal(card)
                }
            }
        }
    }
}

struct CardView: View {
    var card: EmojiMemoryGame.Card
    
    @State private var animatedBonusRemaining: Double = 0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Group {
                    if card.isFaceUp {
                        Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: card.isFaceUp ? 200-90 : 110-90))
                            .onAppear {
                                withAnimation {
                                    animatedBonusRemaining
                                }
                            }
                    } else {
                        Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: card.isFaceUp ? 200-90 : 110-90))
                    }
                }
                    .padding(10)
                    .opacity(0.5)
                
                Text(card.content)
                    .rotationEffect(Angle(degrees: card.isMatched ? 360 : 0))
                    .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false))
                    .font(Font.system(size: Constants.fontSize))
                    .scaleEffect(scale(thatFits: geometry.size))
            }
            .cardify(isFaceUp: card.isFaceUp)
        }
    }
    
    private func scale(thatFits size: CGSize) -> CGFloat {
        min(size.width, size.height) / (Constants.fontSize / Constants.fontScale)
    }
        
    private struct Constants {
        static let fontScale: CGFloat = 0.7
        static let fontSize: CGFloat = 32
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        
        return EmojiMemoryGameView(game: game)
            .preferredColorScheme(.light)
    }
}
