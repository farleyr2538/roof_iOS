//
//  MapTabView.swift
//  Roof
//
//  Created by Robert Farley on 21/09/2024.
//

import SwiftUI
import Foundation
import MapKit

struct MapTabView : View {
    
    @EnvironmentObject var viewModel : ViewModel
        
    var body: some View {
        Group {
            if viewModel.locations.isEmpty {
                ProgressView()
                    .task {
                        await viewModel.reviewsToLocations()
                    }
            } else {
                Map() {
                    ForEach(viewModel.locations) { location in
                        Marker(location.address, coordinate: location.coordinates)
                    }
                }
            }
            
        }
        .ignoresSafeArea()
        
    }
}


#Preview {
    MapTabView()
        .environmentObject(ViewModel())
}
