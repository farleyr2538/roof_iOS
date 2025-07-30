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
            StarsView(number: review.landlord_rating)
        }
        .padding(.vertical, 5)
    }
}

#Preview {
    ReviewListView(review: Review(
        rating_id: UUID(),
        fn: "Rob",
        ln: "Farley",
        address: "Flat 8, Atlantic House, 51-57 Upper Richmond Road",
        postcode: "SW15 2RD",
        landlord_rating: 3,
        years: ["2020, 2021"],
        time:"12 March 2023"
    ))
}
