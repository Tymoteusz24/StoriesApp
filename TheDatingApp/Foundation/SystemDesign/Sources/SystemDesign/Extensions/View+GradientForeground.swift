//
//  View+GradientForeground.swift
//  SystemDesign
//
//  Created by Tymoteusz Pasieka on 10/22/25.
//

import SwiftUI

extension View {
    /// Applies a linear gradient as the foreground (mask) of the view
    /// Perfect for gradient text, icons, and images
    ///
    /// Example:
    /// ```swift
    /// Image(systemName: "flame.fill")
    ///     .gradientForeground(colors: [.orange, .red])
    ///
    /// Text("Gradient Text")
    ///     .gradientForeground(
    ///         colors: [BrandColors.primaryPink, BrandColors.secondaryPurple],
    ///         startPoint: .leading,
    ///         endPoint: .trailing
    ///     )
    /// ```
    public func gradientForeground(
        colors: [Color],
        startPoint: UnitPoint = .top,
        endPoint: UnitPoint = .bottom
    ) -> some View {
        self.overlay(
            LinearGradient(
                gradient: Gradient(colors: colors),
                startPoint: startPoint,
                endPoint: endPoint
            )
        )
        .mask(self)
    }
    
    /// Applies a linear gradient with stops as the foreground
    public func gradientForeground(
        stops: [Gradient.Stop],
        startPoint: UnitPoint = .top,
        endPoint: UnitPoint = .bottom
    ) -> some View {
        self.overlay(
            LinearGradient(
                gradient: Gradient(stops: stops),
                startPoint: startPoint,
                endPoint: endPoint
            )
        )
        .mask(self)
    }
}

// MARK: - Convenience Extensions for Images

@MainActor
extension Image {
    /// Creates an image with a flame gradient (orange to red)
    public func flameGradient() -> some View {
        self.gradientForeground(
            colors: [BrandColors.flameTop, BrandColors.flameBottom],
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    /// Creates an image with the primary brand gradient
    public func brandGradient() -> some View {
        self.gradientForeground(
            colors: [BrandColors.primaryPink, BrandColors.secondaryPurple],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

@MainActor
extension Text {
    /// Creates text with the primary brand gradient
    public func brandGradient() -> some View {
        self.gradientForeground(
            colors: [BrandColors.primaryPink, BrandColors.secondaryPurple],
            startPoint: .leading,
            endPoint: .trailing
        )
    }
}

