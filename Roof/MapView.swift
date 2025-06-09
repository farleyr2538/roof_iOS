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
    
    var review : Review
    
    var address : String {
        review.address + ", " + review.postcode
    }

    var body: some View {
        if let coords = coordinates {
            Map(position: $position) {
                Marker(review.address, coordinate: coords)
                // on tap, show star rating
                // also, make marker nicer
            }
        } else {
            ProgressView()
                .onAppear {
                    viewModel.getCoordinates(address, completion: { coords, pos in
                        DispatchQueue.main.async {
                            self.coordinates = coords
                            self.position = pos
                        }
                    })
                }
        }
    }
}
    
#Preview {
    MapView(review: Review(
        id: UUID(),
        first_name: "Rob",
        last_name: "Farley",
        address: "Flat 8, Atlantic House",
        postcode: "SW15 2RD",
        landlordRating: 3,
        years: ["2020, 2021"],
        timestamp: "12 March 2023"
    ))
    .environmentObject(ViewModel())
}

