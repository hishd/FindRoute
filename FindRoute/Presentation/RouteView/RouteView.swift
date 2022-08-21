//
//  ContentView.swift
//  FindRoute
//
//  Created by Hishara Dilshan on 2022-08-21.
//

import SwiftUI

struct RouteView: View {
    
    @StateObject var viewModel: RouteViewViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter Source", text: $viewModel.fromLocation)
                    .textFieldStyle(.roundedBorder)
                TextField("Enter Destination", text: $viewModel.endLocation)
                    .textFieldStyle(.roundedBorder)
                GoogleMapView()
                    .cornerRadius(10)
            }
            .padding()
            .navigationTitle("Search Route")
            .navigationBarTitleDisplayMode(.automatic)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct RouteViewPreviews: PreviewProvider {
    static var previews: some View {
        RouteView(viewModel: RouteViewViewModel())
            .previewDevice("iPhone 11")
    }
}
