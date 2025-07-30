//
//  ViewReview.swift
//  Roof
//
//  Created by Robert Farley on 15/04/2024.
//

import Foundation
import SwiftUI
import MapKit

struct ReviewView : View {
    
    var review : Review
    
    var body : some View {
        
        VStack {
            MapView(address: review.address + ", " + review.postcode)
            VStack {
                VStack {
                    Text(review.address)
                        .font(.title.bold())
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(review.postcode)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                HStack {
                    Text("Landlord Rating:")
                    Spacer()
                    StarsView(number: review.landlord_rating)
                        .padding(.trailing, 10)
                }
                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    ReviewView(review: Review(
        rating_id: UUID(),
        fn: "Rob",
        ln: "Farley",
        address: "Flat 8, Atlantic House",
        postcode: "SW15 2RD",
        landlord_rating: 3,
        years: ["2020, 2021"],
        time:"12 March 2023"
    ))
    .environmentObject(ViewModel())
}
