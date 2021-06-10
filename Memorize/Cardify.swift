//
//  Cardify.swift
//  Memorize
//
//  Created by Paulo Menezes on 09/06/21.
//

import SwiftUI

struct Cardify: AnimatableModifier {
    var rotation: Double // in degress
    var animatableData: Double {
        get { rotation }
        set { rotation = newValue }
    }
    
    init(isFaceUp: Bool) {
        rotation = isFaceUp ? 0 : 180
    }
    
    func body(content: Content) -> some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: Constants.cornerRadius)
            
            if rotation < 90 {
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: Constants.lineWidth)
            } else {
                shape.fill()
            }

            content
                .opacity(rotation < 90 ? 1 : 0)
        }
        .rotation3DEffect(
            Angle.degrees(rotation),
            axis: (x: 0.0, y: 1.0, z: 0.0)
        )
    }
    
    private struct Constants {
        static let cornerRadius: CGFloat = 10
        static let lineWidth: CGFloat = 3
    }
}

extension View {
    func cardify(isFaceUp: Bool) -> some View {
        return self.modifier(Cardify(isFaceUp: isFaceUp))
    }
}
