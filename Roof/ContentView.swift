//
//  ContentView.swift
//  Roof
//
//  Created by Robert Farley on 29/02/2024.
//

import SwiftUI
import Foundation

struct ContentView: View {
        
    @EnvironmentObject var viewModel : ViewModel
    
    @State var selected : Tab = .reviewsTab
    @State var isLoading = true
    
    enum Tab {
        case reviewsTab
        case mapTab
    }
    
    var body: some View {
        TabView(selection: $selected) {
            if isLoading {
                ProgressView("Loading...")
            } else if viewModel.reviews.isEmpty {
                Text("No Reviews")
                    .foregroundStyle(.gray)
            } else {
                ListTabView()
                    .tabItem {
                        Label("List", systemImage: "list.bullet")
                    }
                    .tag(Tab.reviewsTab)
                MapTabView()
                    .tabItem {
                        Label("Map", systemImage:"map")
                    }
                    .tag(Tab.mapTab)
            }
        }
        .task {
            isLoading = true
            await viewModel.getReviews()
            isLoading = false
        }
        .task {
            await viewModel.reviewsToLocations()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(ViewModel())
}
