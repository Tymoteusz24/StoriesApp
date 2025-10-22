//
//  FeedView.swift
//  Feed
//
//  Created by Tymoteusz Pasieka on 10/22/25.
//

import SwiftUI
import Router

struct FeedView: View {
    @EnvironmentObject private var router: Router
    @StateObject private var viewModel: FeedViewModel
    
    init(dependencies: FeedViewModel.Depedencies) {
        _viewModel = StateObject(wrappedValue: FeedViewModel(dependencies: dependencies))
    }
    
    var body: some View {
        Text("Hello, Feed!")
    }
}

#Preview {
    FeedView(dependencies: .init())
}
