//
//  Database.swift
//  Roof
//
//  Created by Robert Farley on 11/04/2024.
//

import Foundation
import SwiftUI
import MapKit


@MainActor
class ViewModel : ObservableObject {
    
    @Published var reviews : [Review] = []
    @Published var locations: [Location] = []
    @Published var isLoadingData = true
    @Published var hasError : Bool = false
    @Published var errorMessage : String? = nil
    
    private let persistenceService : ReviewPersistence
    private let apiService : APIService
    private let geoService : GeocodeHelper
    
    init(
        persistenceService: ReviewPersistence = .shared,
        apiService: APIService = .shared,
        geoService: GeocodeHelper = .shared
    ) {
        self.persistenceService = persistenceService
        self.apiService = apiService
        self.geoService = geoService
    }
    
    let calendar = Calendar.current
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
    
    func getReviews() async {
        if let cachedReviews = checkCache() {
            print("reviews found in cache")
            self.reviews = cachedReviews
        } else {
            if let fetchedReviews = await apiService.fetchReviews() {
                print("reviews fetched from API")
                self.reviews = fetchedReviews
            } else {
                print("unable to get reviews from cache or fetch")
                hasError = true
            }
        }
    }
    
    func reviewsToLocations() async {
        if self.reviews.isEmpty {
            print("self.reviews empty")
        } else {
            if let locations = await geoService.reviewsToLocations(reviews: self.reviews) {
                self.locations = locations
            } else {
                print("error running geoService.reviewsToLocations")
            }
        }
    }
    
    func getCoordinates(address: String) async -> CLLocationCoordinate2D?  {
        if let coordinates = await geoService.getCoordinates(address) {
            return coordinates
        } else {
            print("unable to get coordinates")
            return nil
        }
    }
    
    
    func checkCache() -> [Review]?  { // check if any reviews in cache
        do {
            if let reviews = try persistenceService.loadReviews() {
                return reviews
            } else {
                return nil
            }
        } catch {
            return nil
        }
    }
    
    func submitReview(_ review: Review) async {
        do {
            try persistenceService.saveReviews([review])
            self.reviews.append(review)
        } catch {
            print("unable to save review to cache")
        }
    }
    
    func printReviews() {
        print("Data Model type: \(type(of: self.reviews))")
        print("Length of array 'data': \(self.reviews.count)")
        for review in self.reviews {
            print("Address: \(review.address)")
            print("Rating: \(review.landlord_rating)")
        }
    }
    
    
    static let dummyData : [Review] = [
        Review(
            rating_id: UUID(),
            fn: "Rob",
            ln: "Farley",
            address: "Flat 8, Atlantic House",
            postcode: "SW15 2RD",
            landlord_rating: 3,
            years: ["2020, 2021"],
            time: "12 March 2023"
        ),
        Review(
            rating_id: UUID(),
            fn: "Kate",
            ln: "Padiachy",
            address: "27 Linver Road",
            postcode: "SW6 3RA",
            landlord_rating: 4,
            years: ["2021"],
            time:"15 March 2023"
        )
    ]
}
