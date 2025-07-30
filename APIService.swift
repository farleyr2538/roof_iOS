//
//  APIService.swift
//  Roof
//
//  Created by Robert Farley on 30/07/2025.
//

import Foundation

class APIService {
    
    static let shared = APIService()
    
    func fetchReviews() async -> [Review]? { // get reviews from API
        
        let url_string = "https://www.rooflondon.uk/api/get_all"
        guard let url = URL(string: url_string) else {
            print("Error creating url")
            return nil
        }
            
        // convert data to JSON
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            let decoder = JSONDecoder()
            let decodedReviews = try decoder.decode([Review].self, from: data)
            return decodedReviews
        } catch {
            print("failed to decode JSON into Reviews: ", error)
            return nil
        }
    }
    
    func submitReview(review : Review) { // submit a review to the API
        
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
}
