//
//  MultiSelectRow.swift
//  Roof
//
//  Created by Robert Farley on 09/06/2025.
//

import SwiftUI

struct MultiSelectRow: View {
    
    var year : String
    var isSelected : Bool
    
    var body: some View {
        HStack {
            Text(year)
            Spacer()
            if isSelected {
                Image(systemName: "checkmark")
                    .foregroundStyle(.blue)
            }
        }
        .contentShape(Rectangle())
    }
}

#Preview {
    MultiSelectRow(
        year: "2024",
        isSelected: true
    )
}
