//
//  reviewPersistence.swift
//  Roof
//
//  Created by Robert Farley on 30/07/2025.
//

import Foundation

class ReviewPersistence {
    static let shared = ReviewPersistence()
    private let fileName = "reviews.json"
    
    private var directoryURL : URL { // URL of app's FileManager
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    private var fileURL : URL { // adding our file name to FileManager path
        directoryURL.appendingPathComponent(fileName)
    }
    
    func saveReviews(_ reviews: [Review]) throws {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(reviews)
            try data.write(to: fileURL)
            print("Reviews saved to: \(fileURL)")
        } catch {
            print("Error saving reviews: \(error)")
        }
    }
    
    func loadReviews() throws -> [Review]? { // returns nil if error, otherwise [Review]
        
        // confirm files exist
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            print("No saved products file found at: \(fileURL.absoluteString)")
            return nil
        }
        
        do {
            let data = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            return try decoder.decode([Review].self, from: data)
        } catch {
            print("Error loading reviews: \(error)")
            return nil
        }
    }
    
}
