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
    
    let mapView = GMSMapView(frame: CGRect.zero, camera: GMSCameraPosition.centerPoint)
    
    func makeUIView(context: Context) -> some UIView {
        return mapView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
    func refreshMapView(directionData: DirectionData?) {
        if let data = directionData {
            mapView.clear()
            data.polyline.map = mapView
            data.sourceMarker.map = mapView
            data.destinationMarker.map = mapView
            
            let camera = GMSCameraPosition(target: data.sourceMarker.position, zoom: 14)
            mapView.animate(to: camera)
        }
    }
}

extension GMSCameraPosition {
    ///The center point of the camera is needed to be set fro Negombo, Sri-Lanka
    static var centerPoint = GMSCameraPosition.camera(withLatitude: 7.217391, longitude: 79.856189, zoom: 14)
}
