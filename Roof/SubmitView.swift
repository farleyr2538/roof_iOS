//
//  SubmitView.swift
//  Roof
//
//  Created by Robert Farley on 15/04/2024.
//

import Foundation
import SwiftUI

struct SubmitView : View {
    
    @EnvironmentObject var viewModel : ViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State var newReview = Review(
        rating_id: UUID(),
        fn: "",
        ln: "",
        address: "",
        postcode: "",
        landlord_rating: 6,
        property_rating: 6,
        years: [],
        time: ""
    )
    
    @State var selectedYears : [String] = []
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("About you")) {
                    TextField("First name", text: $newReview.fn)
                    TextField("Last name", text: $newReview.ln)
                }
                Section(header: Text("About the property")) {
                    TextField("Property address", text: $newReview.address)
                    TextField("Postcode", text: $newReview.postcode)
                }
                Section(header: Text("Years at the property")){
                    List {
                        ForEach(viewModel.years, id: \.self) { year in
                            MultiSelectRow(year: year, isSelected: selectedYears.contains(year))
                                .onTapGesture {
                                    if selectedYears.contains(year) {
                                        selectedYears.removeAll { $0 == year}
                                    } else {
                                        selectedYears.append(year)
                                    }
                                }
                        }
                    }
                }
                Section(header: Text("Landlord rating")) {
                    Picker("landlord rating", selection: $newReview.landlord_rating) {
                        Text("1").tag(1)
                        Text("2").tag(2)
                        Text("3").tag(3)
                        Text("4").tag(4)
                        Text("5").tag(5)
                    }
                    .pickerStyle(.wheel)
                    
                }
                Section(header: Text("Property rating")) {
                    Picker("property rating", selection: $newReview.property_rating) {
                        Text("1").tag(1)
                        Text("2").tag(2)
                        Text("3").tag(3)
                        Text("4").tag(4)
                        Text("5").tag(5)
                    }
                    .pickerStyle(.wheel)
                }
                Section {
                    HStack {
                        Spacer()
                        Button{
                            // assign selected years to review
                            for year in selectedYears {
                                newReview.years.append(year)
                            }
                            
                            // assign current date/time to review
                            let date = viewModel.dateFormatter.string(from: Date())
                            newReview.time = date
                            
                            // submit review
                            Task {
                                await viewModel.submitReview(newReview)
                            }
                            
                            // dismiss view
                            dismiss()
                        } label: {
                            Text("Submit")
                                .padding(10)
                        }
                        .buttonStyle(.borderedProminent)
                        .buttonBorderShape(.capsule)
                        .padding()
                        Spacer()
                    }
                }
                .listRowBackground(Color.clear)
            }
        }
    }
}

#Preview {
    SubmitView()
        .environmentObject(ViewModel())
}
