//
//  MapView.swift
//  Roof
//
//  Created by Robert Farley on 22/04/2024.
//

import Foundation
import SwiftUI
import MapKit

// the aim usage is:
    // MapView(review)
// this returns a map View of the address of the property

struct MapView : View {

    @EnvironmentObject var viewModel : ViewModel
    
    @State var coordinates : CLLocationCoordinate2D?
    @State var position : MapCameraPosition = .automatic
    
    let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    
    var address : String

    var body: some View {
        if let coords = coordinates {
            Map(position: $position) {
                Marker(address, coordinate: coords)
                // on tap, show star rating
                // also, make marker nicer
            }
        } else {
            ProgressView()
                .onAppear {
                    Task {
                        await coordinates = viewModel.getCoordinates(address: address)
                        if let coordinates = coordinates {
                            position = .region(MKCoordinateRegion(
                                center: coordinates,
                                span: span
                            ))
                        }
                    }
                }
        }
    }
}
    
#Preview {
    MapView(address: "Flat 8, Atlantic House, SW15 2RD")
    .environmentObject(ViewModel())
}

