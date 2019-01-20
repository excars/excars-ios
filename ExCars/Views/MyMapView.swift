//
//  MapView.swift
//  ExCars
//
//  Created by Леша Маслаков on 20/01/2019.
//  Copyright © 2019 Леша. All rights reserved.
//

import UIKit

import GoogleMaps


class MyMapView: XibView {

    @IBOutlet weak var mapView: GMSMapView!
    
    var onDidTapSettings: (() -> Void)?
    
    let defaultLocation = CLLocationCoordinate2D(latitude: 34.67, longitude: 33.04)
    let zoomLevel: Float = 15.0
    
    init() {
        super.init(nibName: "MyMapView", frame: CGRect.zero)
        setupMapView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupMapView() {
        mapView.frame = bounds
        mapView.camera = GMSCameraPosition(target: defaultLocation, zoom: zoomLevel, bearing: 0.0, viewingAngle: 0.0)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.padding = UIEdgeInsets(top: view.safeAreaInsets.top, left: 0.0, bottom: 80.0, right: 0.0)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    @IBAction func didTapSettings() {
        onDidTapSettings?()
    }
    
}
