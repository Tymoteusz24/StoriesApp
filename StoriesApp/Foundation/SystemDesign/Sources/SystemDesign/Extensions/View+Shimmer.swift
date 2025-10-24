//
//  View+Shimmer.swift
//  SystemDesign
//
//  Created by Tymoteusz Pasieka on 10/24/25.
//

import SwiftUI

public struct ShimmerEffect: ViewModifier {
    @State private var phase: CGFloat = 0
    
    public func body(content: Content) -> some View {
        content
            .overlay(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.clear,
                        Color.white.opacity(0.3),
                        Color.clear
                    ]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .rotationEffect(.degrees(30))
                .offset(x: phase)
                .mask(content)
            )
            .onAppear {
                withAnimation(
                    Animation.linear(duration: 1.5)
                        .repeatForever(autoreverses: false)
                ) {
                    phase = 400
                }
            }
    }
}

public extension View {
    func shimmer() -> some View {
        modifier(ShimmerEffect())
    }
}

