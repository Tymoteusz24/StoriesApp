//
//  BrandColors.swift
//  SystemDesign
//
//  Created by Tymoteusz Pasieka on 10/22/25.
//

import SwiftUI

/// Brand colors for the dating app (inspired by Down app)
public enum BrandColors {
    
    // MARK: - Primary Colors
    
    /// Primary brand pink/magenta color
    /// Used for: Primary buttons, highlights, verification badges
    public static let primaryPink = Color(red: 1.0, green: 0.0, blue: 0.42)  // #FF006B
    
    /// Secondary purple accent
    /// Used for: Gradients, secondary elements
    public static let secondaryPurple = Color(red: 0.8, green: 0.0, blue: 0.8)  // #CC00CC
    
    /// Vibrant pink for active states
    public static let hotPink = Color(red: 1.0, green: 0.08, blue: 0.58)  // #FF1493
    
    // MARK: - Flame Colors (for hot/trending indicators)
    
    /// Top of flame gradient (orange)
    public static let flameTop = Color(red: 1.0, green: 0.5, blue: 0.0)  // #FF8000
    
    /// Bottom of flame gradient (deep red)
    public static let flameBottom = Color(red: 1.0, green: 0.2, blue: 0.2)  // #FF3333
    
    // MARK: - UI Colors
    
    /// Background dark
    public static let backgroundDark = Color(red: 0.05, green: 0.05, blue: 0.05)  // #0D0D0D
    
    /// Card background (slightly lighter)
    public static let cardBackground = Color(red: 0.12, green: 0.12, blue: 0.12)  // #1E1E1E
    
    /// Text primary (white)
    public static let textPrimary = Color.white
    
    /// Text secondary (gray)
    public static let textSecondary = Color(red: 0.6, green: 0.6, blue: 0.6)  // #999999
    
    // MARK: - Action Colors
    
    /// Like/Date button color (heart gradient)
    public static let likeGradientStart = Color(red: 0.5, green: 0.3, blue: 1.0)  // Purple
    public static let likeGradientEnd = Color(red: 1.0, green: 0.3, blue: 0.5)    // Pink
    
    /// Skip/Pass button color
    public static let skipGray = Color(red: 0.3, green: 0.3, blue: 0.3)  // #4D4D4D
    
    /// Message/Chat button color
    public static let chatGray = Color(red: 0.4, green: 0.4, blue: 0.4)  // #666666
    
    // MARK: - Gradient Definitions
    
    /// Primary brand gradient (pink to purple)
    public static var primaryGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [primaryPink, secondaryPurple]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    /// Flame gradient (orange to red)
    public static var flameGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [flameTop, flameBottom]),
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    /// Like button gradient
    public static var likeGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [likeGradientStart, likeGradientEnd]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    /// Card overlay gradient (for text readability)
    public static var cardOverlay: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [.clear, .black.opacity(0.9)]),
            startPoint: .center,
            endPoint: .bottom
        )
    }
}

// MARK: - Preview Helpers

#if DEBUG
struct BrandColors_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Primary Colors
                Group {
                    Text("Primary Colors")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    ColorSwatch(name: "Primary Pink", color: BrandColors.primaryPink)
                    ColorSwatch(name: "Secondary Purple", color: BrandColors.secondaryPurple)
                    ColorSwatch(name: "Hot Pink", color: BrandColors.hotPink)
                }
                
                Divider()
                
                // Flame Colors
                Group {
                    Text("Flame Colors")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    ColorSwatch(name: "Flame Top", color: BrandColors.flameTop)
                    ColorSwatch(name: "Flame Bottom", color: BrandColors.flameBottom)
                }
                
                Divider()
                
                // Gradients
                Group {
                    Text("Gradients")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    RoundedRectangle(cornerRadius: 10)
                        .fill(BrandColors.primaryGradient)
                        .frame(height: 60)
                        .overlay(Text("Primary Gradient").foregroundColor(.white))
                    
                    RoundedRectangle(cornerRadius: 10)
                        .fill(BrandColors.flameGradient)
                        .frame(height: 60)
                        .overlay(Text("Flame Gradient").foregroundColor(.white))
                    
                    RoundedRectangle(cornerRadius: 10)
                        .fill(BrandColors.likeGradient)
                        .frame(height: 60)
                        .overlay(Text("Like Gradient").foregroundColor(.white))
                }
                
                Divider()
                
                // Icon Examples
                Group {
                    Text("Icon Examples")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    HStack(spacing: 30) {
                        Image(systemName: "flame.fill")
                            .flameGradient()
                            .font(.system(size: 40))
                           
                        
                        Image(systemName: "heart.fill")
                            .brandGradient()
                            .font(.system(size: 40))
                           
                        
                        Image(systemName: "star.fill")
                            .font(.system(size: 40))
                            .gradientForeground(colors: [.yellow, .orange])
                    }
                }
                
                Divider()
                
                // Text Examples
                Group {
                    Text("Text Examples")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("Gradient Text")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .brandGradient()
                    
                    Text("Custom Gradient")
                        .font(.title)
                        .fontWeight(.semibold)
                        .gradientForeground(
                            colors: [BrandColors.flameTop, BrandColors.flameBottom],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                }
            }
            .padding()
        }
        .background(BrandColors.backgroundDark)
    }
    
    struct ColorSwatch: View {
        let name: String
        let color: Color
        
        var body: some View {
            HStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(color)
                    .frame(width: 60, height: 60)
                
                Text(name)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
            }
        }
    }
}
#endif

