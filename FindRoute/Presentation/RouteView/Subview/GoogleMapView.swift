//
//  GoogleMapView.swift
//  FindRoute
//
//  Created by Hishara Dilshan on 2022-08-21.
//

import Foundation
import SwiftUI
import GoogleMaps

struct GoogleMapView: UIViewRepresentable {
    func makeUIView(context: Context) -> some UIView {
        let mapView = GMSMapView(frame: CGRect.zero, camera: GMSCameraPosition.centerPoint)
        return mapView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}

extension GMSCameraPosition {
    ///The center point of the camera is needed to be set fro Negombo, Sri-Lanka
    static var centerPoint = GMSCameraPosition.camera(withLatitude: 7.217391, longitude: 79.856189, zoom: 14)
}
