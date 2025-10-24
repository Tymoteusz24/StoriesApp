//
//  ErrorView.swift
//  Stories
//
//  Created by Tymoteusz Pasieka on 10/24/25.
//

import SwiftUI

struct ErrorView: View {
    let message: String
    let onRetry: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 50))
                .foregroundColor(.orange)
            
            Text("Oops!")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text(message)
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Button(action: onRetry) {
                HStack {
                    Image(systemName: "arrow.clockwise")
                    Text("Try Again")
                }
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .padding(.horizontal, 30)
                .padding(.vertical, 12)
                .background(Color.blue)
                .cornerRadius(25)
            }
            .padding(.top, 10)
        }
    }
}

struct ErrorToastView: View {
    let message: String
    let onRetry: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "exclamationmark.circle.fill")
                .foregroundColor(.orange)
            
            Text(message)
                .font(.caption)
                .foregroundColor(.white)
            
            Spacer()
            
            Button(action: onRetry) {
                HStack(spacing: 4) {
                    Image(systemName: "arrow.clockwise")
                    Text("Retry")
                }
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.white.opacity(0.2))
                .cornerRadius(8)
            }
        }
        .padding(12)
        .background(Color.red.opacity(0.8))
        .cornerRadius(12)
    }
}

#Preview("Error View") {
    ZStack {
        Color.black.edgesIgnoringSafeArea(.all)
        ErrorView(
            message: "Network connection failed. Please try again.",
            onRetry: {}
        )
    }
}

#Preview("Error Toast View") {
    ZStack {
        Color.black.edgesIgnoringSafeArea(.all)
        VStack {
            Spacer()
            ErrorToastView(
                message: "Failed to load more stories.",
                onRetry: {}
            )
            .padding()
            Spacer()
        }
    }
}

