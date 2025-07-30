//
//  ListView.swift
//  Roof
//
//  Created by Robert Farley on 21/09/2024.
//

import SwiftUI
import Foundation

struct ListTabView : View {
    
    @EnvironmentObject var viewModel : ViewModel
    
    @State var searchText : String = ""
    
    var filteredItems : [Review] {
        if searchText.isEmpty {
            return viewModel.reviews
        } else {
            return viewModel.reviews.filter {
                $0.address.lowercased().contains(searchText.lowercased())
                ||
                $0.postcode.lowercased().contains(searchText.lowercased())
            }
        }
        
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredItems) { review in
                    NavigationLink {
                        ReviewView(review: review)
                            .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
                    } label: {
                        ReviewListView(review: review)
                            .foregroundStyle(.black)
                    }
                }
            }
            .navigationTitle("Reviews")
            .toolbar {
                ToolbarItem {
                    NavigationLink {
                        SubmitView()
                            .navigationTitle("Review your landlord")
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Search")
            
            if filteredItems.isEmpty {
                VStack {
                    // Spacer()
                    Text("no results")
                        .foregroundStyle(.gray)
                    Spacer()
                }
            }
            
        }
        
    }
}

/*
#Preview {
    ListView()
        .environmentObject(ViewModel())
}
 */

struct ListViewPreview : PreviewProvider {
    static var previews : some View {
        let mockViewModel = ViewModel()
        mockViewModel.reviews = ViewModel.dummyData
        
        return ListTabView()
            .environmentObject(mockViewModel)
    }
    
}
