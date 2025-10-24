//
//  SwipeableCardView.swift
//  Feed
//
//  Created by Tymoteusz Pasieka on 10/22/25.
//

import SwiftUI
import SystemDesign

// MARK: - Swipe Direction

enum SwipeDirection {
    case up, down, none
    
    var title: String {
        switch self {
        case .up: return "DATE"
        case .down: return "DOWN"
        case .none: return ""
        }
    }
    
    var color: Color {
        switch self {
        case .up: return BrandColors.primaryPink
        case .down: return BrandColors.flameTop
        case .none: return .clear
        }
    }
    
    @MainActor
    @ViewBuilder
    var icon: some View {
        switch self {
        case .up:
            Image(systemName: "heart.fill")
                .brandGradient()
        case .down:
            Image(systemName: "flame.fill")
                .flameGradient()
        case .none:
            EmptyView()
        }
    }
}

// MARK: - Swipe Indicator View

struct SwipeIndicatorView: View {
    let direction: SwipeDirection
    let opacity: Double
    
    var body: some View {
        ZStack {
            HStack(spacing: 8) {
                direction.icon
                    .font(.system(size: 50))
                
                Text(direction.title)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(direction.color)
            }
        }
        .padding(.vertical, Design.Spacing.system)
        .padding(.horizontal, Design.Spacing.expanded)
        .background(.white.opacity(0.8))
        .clipShape(.capsule)
        .opacity(opacity)
    }
}

// MARK: - Swipeable Card View

struct SwipeableCardView<Content: View>: View {
    let content: Content
    let onSwipeUp: () -> Void
    let onSwipeDown: () -> Void
    
    @State private var offset: CGSize = .zero
    private var screenHeight: CGFloat = UIScreen.main.bounds.height
    
    // Swipe threshold (20% of screen height)
    private var swipeThreshold: CGFloat {
        200
    }
    
    init(
        onSwipeUp: @escaping () -> Void,
        onSwipeDown: @escaping () -> Void,
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        self.onSwipeUp = onSwipeUp
        self.onSwipeDown = onSwipeDown
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Card content
                content
                // Swipe indicator overlay
                SwipeIndicatorView(
                    direction: getSwipeDirection(),
                    opacity: getIndicatorOpacity()
                )
            }
            .offset(y: offset.height)
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        offset = CGSize(width: 0, height: gesture.translation.height)
                    }
                    .onEnded { gesture in
                        handleSwipeEnd(gesture: gesture)
                    }
            )
            .animation(.spring(response: 0.5, dampingFraction: 0.7), value: offset)
        }
    }
    
    private func getSwipeDirection() -> SwipeDirection {
        if offset.height < -50 {
            return .up
        } else if offset.height > 50 {
            return .down
        }
        return .none
    }
    
    private func getIndicatorOpacity() -> Double {
        let progress = abs(offset.height) / swipeThreshold
        print("Swipe progress: \(progress), offset: \(offset.height), threshold: \(swipeThreshold)")
        return min(Double(progress), 1.0)
    }
    
    private func handleSwipeEnd(gesture: DragGesture.Value) {
        let verticalMovement = gesture.translation.height
        let velocity = gesture.predictedEndTranslation.height
        
        // Swipe Up (Like/Date)
        if verticalMovement < -swipeThreshold || velocity < -1000 {
            animateSwipeUp()
        }
        // Swipe Down (Skip/Pass)
        else if verticalMovement > swipeThreshold || velocity > 1000 {
            animateSwipeDown()
        }
        // Return to center
        else {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                offset = .zero
            }
        }
    }
    
    private func animateSwipeUp() {
        withAnimation(.easeOut(duration: 0.25)) {
            offset = CGSize(width: 0, height: -screenHeight * 1.5)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            onSwipeUp()
            // Don't reset offset - let the view disappear off-screen
        }
    }
    
    private func animateSwipeDown() {
        withAnimation(.easeOut(duration: 0.25)) {
            offset = CGSize(width: 0, height: screenHeight * 1.5)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            onSwipeDown()
            // Don't reset offset - let the view disappear off-screen
        }
    }
}

