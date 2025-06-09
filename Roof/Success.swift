//
//  success.swift
//  Roof
//
//  Created by Robert Farley on 15/08/2024.
//

import Foundation
import SwiftUI

struct SuccessView : View {
    var body : some View {
        VStack {
            Spacer()
            Text("Thank you!")
                .font(.title)
            Spacer()
            NavigationLink(destination: ContentView()) {
                Text("Home")
                    .padding(20)
            }
            .background(.blue)
            .foregroundStyle(.white)
            .containerShape(.capsule)
            .padding(.bottom, 20)
        }
    }
}

#Preview {
    SuccessView()
}
