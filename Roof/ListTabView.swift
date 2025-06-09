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
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.reviews) { review in
                    NavigationLink {
                        ReviewView(review: review)
                            //.navigationBarTitleDisplayMode(.inline)
                            .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
                            //.toolbarBackground(.visible, for: .navigationBar)
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
