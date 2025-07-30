//
//  RoofApp.swift
//  Roof
//
//  Created by Robert Farley on 29/02/2024.
//

import SwiftUI

@main
struct RoofApp: App {
    
    @StateObject var viewModel = ViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
