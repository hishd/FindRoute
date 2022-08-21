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
                HStack {
                    TextField("Enter Source", text: $viewModel.sourceLocationQuery)
                        .textFieldStyle(.roundedBorder)
                    .focused($focusField, equals: .isSource)
                    
                    Button("Clear") {
                        viewModel.clearSourceLocation()
                    }
                }
                if viewModel.isSearchingSourceLocations {
                    SearchResultsView(locations: viewModel.searchResults) { location in
                        withAnimation {
                            viewModel.selectedSourceLocation = location
                            focusField = nil
                        }
                    }
                }
                HStack {
                    TextField("Enter Destination", text: $viewModel.destinationLocationQuery)
                        .textFieldStyle(.roundedBorder)
                    .focused($focusField, equals: .isDestination)
                    Button("Clear") {
                        viewModel.clearDestinationLocation()
                    }
                }
                if viewModel.isSearchingDestinationLocations {
                    SearchResultsView(locations: viewModel.searchResults) { location in
                        withAnimation {
                            viewModel.selectedDestinationLocation = location
                            focusField = nil
                        }
                    }
                }
                
                Button("Search Route") {
                    viewModel.handleSearchRoute()
                }
                .buttonStyle(.bordered)
                .padding()
                
                if viewModel.isError {
                    Text(viewModel.errorMessage)
                        .foregroundColor(.red)
                        .font(Font.system(size: 18, weight: .semibold, design: .default))
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
