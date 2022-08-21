//
//  SearchResultsView.swift
//  FindRoute
//
//  Created by Hishara Dilshan on 2022-08-22.
//

import Foundation
import SwiftUI

struct SearchResultsView: View {
    
    let locations: [Location]
    let onSelected: (Location) -> Void
    
    var body: some View {
        ZStack {
            if locations.isEmpty {
                ProgressView("Locaing...!")
            }
            
            List(locations, id: \.id) { location in
                Text(location.name)
                    .onTapGesture {
                        onSelected(location)
                    }
            }
            .listStyle(.plain)
        }
        .frame(maxWidth: .infinity, maxHeight: 200)
    }
}
