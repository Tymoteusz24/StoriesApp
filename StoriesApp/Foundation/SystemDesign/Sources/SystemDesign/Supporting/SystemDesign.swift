// The Swift Programming Language
// https://docs.swift.org/swift-book

import UIKit

public enum Design {
    public enum Spacing {
        public static let `default`: CGFloat = 16
        public static let expanded: CGFloat = 24
        public static let minimum: CGFloat = 4
        public static let system: CGFloat = 8
        public static let wide: CGFloat = 32
    }
    
    public enum Card {
        public static let cornerRadius: CGFloat = 30
    }
    
    public enum Buttons {
        public static let smallHeight: CGFloat = 44
        public static let mediumHeight: CGFloat = 50
        public static let largeHeight: CGFloat = 60
        
    }
}
