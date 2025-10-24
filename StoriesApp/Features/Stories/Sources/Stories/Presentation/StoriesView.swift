//
//  StoriesView.swift
//  Stories
//
//  Created by Tymoteusz Pasieka on 10/22/25.
//

import SwiftUI
import Router
import DomainData
import DomainDataMock
import SystemDesign

struct StoriesView: View {
    @EnvironmentObject private var router: Router
    @StateObject private var viewModel: StoriesViewModel
    
    init(dependencies: StoriesViewModel.Depedencies) {
        _viewModel = StateObject(wrappedValue: StoriesViewModel(dependencies: dependencies))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // top buttons
        }
    }
}

#Preview {
    Text("Preview placeholder")
}
