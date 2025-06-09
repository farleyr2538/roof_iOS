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
            MapView(review: review)
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
                    StarsView(number: review.landlordRating)
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
        id: UUID(),
        first_name: "Rob",
        last_name: "Farley",
        address: "Flat 8, Atlantic House",
        postcode: "SW15 2RD",
        landlordRating: 3,
        years: ["2020, 2021"],
        timestamp:"12 March 2023"
    ))
    .environmentObject(ViewModel())
}
