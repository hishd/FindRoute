//
//  ContentView.swift
//  FindRoute
//
//  Created by Hishara Dilshan on 2022-08-21.
//

import SwiftUI

struct RouteView: View {
    
    @StateObject var viewModel: RouteViewViewModel
    @FocusState private var focusField: FocusedField?
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter Source", text: $viewModel.fromLocation)
                    .textFieldStyle(.roundedBorder)
                    .focused($focusField, equals: .isSource)
                if viewModel.isSearchingSourceLocations {
                    SearchResultsView(locations: viewModel.searchResults) { location in
                        withAnimation {
                            viewModel.selectedSourceLocation = location
                        }
                    }
                }
                TextField("Enter Destination", text: $viewModel.endLocation)
                    .textFieldStyle(.roundedBorder)
                    .focused($focusField, equals: .isDestination)
                if viewModel.isSearchingDestinationLocations {
                    SearchResultsView(locations: viewModel.searchResults) { location in
                        withAnimation {
                            viewModel.selectedDestinationLocation = location
                        }
                    }
                }
//                GoogleMapView()
//                    .cornerRadius(10)
                Spacer()
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                    Button("Done") {
                        focusField = nil
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                }
            }
            .navigationTitle("Search Route")
            .navigationBarTitleDisplayMode(.automatic)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct RouteViewPreviews: PreviewProvider {
    static let viewModel = DIContainer.shared.container.resolve(RouteViewViewModel.self)
    
    static var previews: some View {
        if let viewModel = viewModel {
            RouteView(viewModel: viewModel)
                .previewDevice("iPhone 11")
        } 
    }
}

struct SearchResultsView: View {
    
    let locations: [Location]
    let onSelected: (Location) -> Void
    
    var body: some View {
        ZStack {
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
