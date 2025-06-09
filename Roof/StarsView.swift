//
//  StarsView.swift
//  Roof
//
//  Created by Robert Farley on 15/04/2024.
//

import Foundation
import SwiftUI

struct StarsView : View {
    
    var number : Int
    
    var body : some View {
        HStack {
            ForEach(0..<number, id: \.self) { star in
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                    .frame(width: 14, height: 20)
            }
        }
    }
}

#Preview {
    StarsView(number: 3)
}
