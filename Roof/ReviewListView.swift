//
//  ReviewListView.swift
//  Roof
//
//  Created by Robert Farley on 18/04/2024.
//

import Foundation
import SwiftUI

struct ReviewListView : View {
    
    var review : Review
    
    var body : some View {
        HStack {
            VStack (alignment: .leading) {
                Text(review.address)
                    .font(.headline)
                    .multilineTextAlignment(.leading)
                Text(review.postcode)
                    .font(.footnote)
                    
            }
            Spacer()
            StarsView(number: review.landlordRating)
        }
        .padding(.vertical, 5)
    }
}

#Preview {
    ReviewListView(review: Review(
        id: UUID(),
        first_name: "Rob",
        last_name: "Farley",
        address: "Flat 8, Atlantic House, 51-57 Upper Richmond Road",
        postcode: "SW15 2RD",
        landlordRating: 3,
        years: ["2020, 2021"],
        timestamp:"12 March 2023"
    ))
}
