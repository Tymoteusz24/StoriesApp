//
//  MainTabView.swift
//  StoriesApp
//
//  Created by Tymoteusz Pasieka on 10/22/25.
//

import SwiftUI
import Router
import SystemDesign


struct MainTabView: View {
    @State private var selection = 0
    @ObservedObject private var router = Router()
    var body: some View {
        TabView(selection: $selection) {
            FeedTabCoordinator()
                .tabItem {
                    Image(systemName: "person.circle")
                        .foregroundStyle(Color.black)
                    Text(L10n.feedTabTitle)
                }
                .tag(0)
                .toolbarBackground(Asset.Colors.white.swiftUIColor, for: .tabBar)
        }
       .environmentObject(router)
    }
}

#Preview {
    MainTabView()
}
