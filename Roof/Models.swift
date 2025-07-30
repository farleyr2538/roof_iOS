//
//  Models.swift
//  Roof
//
//  Created by Robert Farley on 30/07/2025.
//

import Foundation
import MapKit

struct Review : Hashable, Identifiable, Codable {
    var rating_id = UUID()
    var fn : String
    var ln : String
    var address : String
    var postcode : String
    var landlord_rating : Int
    var property_rating : Int?
    var years : [String]
    var time : String?
    
    var id : UUID { rating_id }
}

struct Location : Identifiable, Equatable {
    let id = UUID()
    var address : String
    var coordinates : CLLocationCoordinate2D

    // comply with equatable
    static func == (lhs: Location, rhs: Location) -> Bool {
        return
            lhs.id == rhs.id &&
            lhs.address == rhs.address &&
            lhs.coordinates.latitude == rhs.coordinates.latitude &&
            lhs.coordinates.longitude == rhs.coordinates.longitude
    }
}
