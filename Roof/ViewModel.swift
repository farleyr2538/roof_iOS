//
//  Database.swift
//  Roof
//
//  Created by Robert Farley on 11/04/2024.
//

import Foundation
import SwiftUI
import MapKit

struct Review : Hashable, Identifiable, Codable {
    var id = UUID()
    var first_name : String
    var last_name : String
    var address : String
    var postcode : String
    var landlordRating : Int
    var propertyRating : Int?
    var years : [String]
    var timestamp : String?
}

struct Location : Identifiable, Equatable {
    let id = UUID()
    var address : String
    var coordinates : CLLocationCoordinate2D

    static func == (lhs: Location, nhs: Location) -> Bool {
        return
            lhs.id == nhs.id &&
            lhs.address == nhs.address &&
            lhs.coordinates.latitude == nhs.coordinates.latitude &&
            lhs.coordinates.longitude == nhs.coordinates.longitude
    }
}

@MainActor
class ViewModel : ObservableObject {
    
    @Published var reviews : [Review] = []
    @Published var locations: [Location] = []
    
    let geocoder = CLGeocoder()
    let calendar = Calendar.current
    
    // date & time formatter
    var dateFormatter : DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        return formatter
    }
    
    var years = [
        "2019",
        "2020",
        "2021",
        "2022",
        "2023",
        "2024",
        "2025"
    ]
    
    func printReviews() {
        print("Data Model type: \(type(of:self.reviews))")
        print("Length of array 'data': \(self.reviews.count)")
        for review in self.reviews {
            print("Address: \(review.address)")
            print("Rating: \(review.landlordRating)")
        }
    }
    
    func geocodeAddress(address : String) async {
        do {
            let placemarks = try await geocoder.geocodeAddressString(address)
            if let placemark = placemarks.first, let coordinate = placemark.location?.coordinate {
                let split_address = String(address.split(separator: ",").first!)
                let location = Location(address: split_address, coordinates: coordinate)
                locations.append(location)
            }
        } catch {
            print("Geocoding error for: \(address)")
        }
    }
    
    func reviewsToLocations() async {
        for review in self.reviews {
            let full_address = review.address + ", " + review.postcode
            await geocodeAddress(address: full_address)
        }
    }

    func fetchData() async {
        
        let url_string = "https://www.rooflondon.uk/api/get_all"
        guard let url = URL(string: url_string) else {
            print("Error creating url")
            return
        }
            
        // convert data to JSON
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let dict_array = try JSONSerialization.jsonObject(with: data) as? [[String: Any]]
            
            if let unwrapped_array = dict_array {
                
                let data_array = unwrapped_array.compactMap { dict -> Review? in
                    // assign JSON values to variables
                    guard let id = dict["rating_id"] as? UUID? ?? UUID(),
                          let postcode = dict["postcode"] as? String,
                          let address = dict["address"] as? String,
                          let rating = dict["landlord_rating"] as? Int,
                          let years = dict["years"] as? [String]
                    else {
                        print("unable to unwrap data")
                        return nil
                    }
                    return Review(
                        id: id,
                        first_name : dict["first_name"] as? String ?? "first_name missing",
                        last_name : dict["last_name"] as? String ?? "last_name missing",
                        address : address,
                        postcode: postcode,
                        landlordRating: rating,
                        years: years,
                        timestamp: dict["time"] as? String
                    )
                }
                self.reviews = data_array
            } else {
                print("Data type is not the expected array of dictionaries")
                return
            }
        } catch {
            print("Unable to convert data to JSON: \(error.localizedDescription)")
        }
    }
    
    // convert address into location
    func getCoordinates(_ full_address: String, completion: @escaping (CLLocationCoordinate2D, MapCameraPosition) -> Void) {
        
        let fallback = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194) // San Francisco
        let zoom = 10000.0
        
        geocoder.geocodeAddressString(full_address) { (placemarks, error) in
            if let error = error {
                print("Error finding address location: \(full_address): \(error.localizedDescription)")
                completion(fallback, .camera(MapCamera(centerCoordinate: fallback, distance: zoom)))
                return
            }
            if let location = placemarks?.first?.location?.coordinate {
                DispatchQueue.global(qos: .userInteractive).async {
                    let coordinates = location
                    let position = MapCameraPosition.camera(
                        MapCamera(centerCoordinate: coordinates, distance: zoom)
                    )
                    completion(location, position)
                }
            } else {
                print("No locations found")
                completion(fallback, .camera(MapCamera(centerCoordinate: fallback, distance: zoom)))
            }
        }
    }
    
    /*
    func loadGeoData() {
        locations.removeAll()
        let dispatchGroup = DispatchGroup()
        print("loadGeoData() running...")
        if self.data.isEmpty {
            print("no data")
        } else {
            let length = self.data.count
            print("data is populated: \(length) items found")
        }
        for review in self.data {
            let full_address : String = review.address + ", " + review.postcode
            
            dispatchGroup.enter()
            
            geocodeAddress(address: full_address)
        }
        dispatchGroup.notify(queue: .main) {
            print("geocoding complete. Total items: \(self.locations.count)")
        }
        print("Length of locations array: \(locations.count)")
    }
     */
    
    func submitReview(review : Review) {
        print("submitReview running...")
        
        // set up URL request
        let baseURL = "https://www.rooflondon.uk/"
        let apiURL = "api/submit"
        guard let fullURL = URL(string: baseURL + apiURL) else {
            print("Invalid URL")
            return
        }
        var request = URLRequest(url: fullURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        print("URL request set up successfully.")
        
        // encode review to JSON data
        print("encoding review to JSON")
        do {
            let jsonData = try JSONEncoder().encode(review)
            request.httpBody = jsonData
            print("review encoded successfully")
        } catch {
            print("Error converting model to Dictionary. Error: \(error.localizedDescription)")
            return
        }
        print("JSON encoded")
        
        print("creating URL Session")
        // create URLSession
        URLSession.shared.dataTask(with: request) { data, error, response in
            // catch error
            if let error = error {
                print("Error: \(error.debugDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("Server Error: \(error.debugDescription)")
                return
            }
            
            // check for data
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print("Response JSON: \(json)")
                } catch {
                    print("JSON Error: \(error.localizedDescription)")
                }
            } else {
                print("No data returned. Error: \(error.debugDescription)")
                return
            }
        }
        .resume()
    }
    
    static let dummyData : [Review] = [
        Review(id: UUID(), first_name: "Rob", last_name: "Farley", address: "Flat 8, Atlantic House", postcode: "SW15 2RD", landlordRating: 3, years: ["2020, 2021"], timestamp:"12 March 2023"),
        Review(id: UUID(), first_name: "Kate", last_name: "Padiachy", address: "27 Linver Road", postcode: "SW6 3RA", landlordRating: 4, years: ["2021"], timestamp:"15 March 2023"),
    ]
}
