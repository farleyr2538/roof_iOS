//
//  GeocodeHelper.swift
//  Roof
//
//  Created by Robert Farley on 30/07/2025.
//

import Foundation
import MapKit

class GeocodeHelper {
    
    static let shared = GeocodeHelper()
    
    let geocoder = CLGeocoder()
    
    // asynchronously return an array of Locationsgenerated from each Review in 'review's address and postcode
    func reviewsToLocations(reviews: [Review]) async -> [Location]? {
        
        print("running reviewsToLocations()")
        
        if reviews.isEmpty {
            print("no reviews to get locations of")
        } else {
            
            var locations : [Location] = []
            
            print("getting locations...")
            
            for review in reviews {
                let full_address = review.address + ", " + review.postcode
                if let coordinates = await getCoordinates(full_address) {
                    let split_address = String(full_address.split(separator: ",").first!)
                    let location = Location(address: split_address, coordinates: coordinates)
                    locations.append(location)
                } else {
                    print("unable to get coordinates for \(review.address), \(review.postcode)")
                }
                
            }
            
            return locations
            
        }
        
        return nil
        
    }
    
    // asynchronously get coordinates for a specific address
    func getCoordinates(_ full_address: String) async -> CLLocationCoordinate2D? {
        
        
        do {
            let placemarks = try await geocoder.geocodeAddressString(full_address)
            
            if let placemark = placemarks.first, let coordinate = placemark.location?.coordinate {
                return coordinate
            } else {
                print("No locations found for address: \(full_address)")
                return nil
            }
        } catch {
            print("error getting coordinates for \(full_address): \(error.localizedDescription)")
            return nil
        }
    }
    
}
