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
    
    var onDidTapMapItem: ((MapItem) -> Void)?
    var onDidTapSettings: (() -> Void)?
    
    private(set) public var markers: [String: GMSMarker] = [:]

    var isLocationAllowed: Bool {
        didSet {
            (isLocationAllowed) ? allowLocation() : disallowLocation()
        }
    }
    
    private let durationTreshhold = 1.0
    
    private let defaultLocation = CLLocationCoordinate2D(latitude: 34.67, longitude: 33.04)
    private let zoomLevel: Float = 15.0
    
    private var cameraLockedOnMe: Bool = true
    private var cameraLockedOnProfile: Bool = false
    
    private var currentMarker: GMSMarker?
    
    init() {
        isLocationAllowed = false
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
        mapView.delegate = self
    }
    
    @IBAction func didTapSettings() {
        onDidTapSettings?()
    }
    
    func lockCameraOnMe() {
        cameraLockedOnMe = true
        cameraLockedOnProfile = false
    }
    
    func lockCameraOn(_ marker: GMSMarker) {
        cameraLockedOnMe = false
        cameraLockedOnProfile = true
        currentMarker = marker
    }

    func unlockCamera() {
        cameraLockedOnMe = false
        cameraLockedOnProfile = false
        currentMarker = nil
    }

    func setCurrentLocation(location: CLLocation) {
        let camera = GMSCameraPosition.camera(
            withLatitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude,
            zoom: mapView.camera.zoom
        )
        
        if mapView.isHidden {
            mapView.isHidden = false
            mapView.camera = camera
        } else {
            if cameraLockedOnMe {
                mapView.animate(to: camera)
            }
        }
    }
    
    func drawMapItems(items: [MapItem]) {
        mapView.clear()
        
        let carIcon = UIImage(named: "car")
        let hitchhikerIcon = UIImage(named: "hitchhiker")
        
        for item in items {
            let marker = markers[item.uid] ?? GMSMarker()
            marker.map = mapView
            marker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
            
            switch item.role {
            case .driver:
                marker.icon = carIcon
            case .hitchhiker:
                marker.icon = hitchhikerIcon
            }
            
            let data = marker.userData as? MapItem
            marker.userData = item
            
            moveMarker(marker, from: data?.location, to: item.location)
            
            markers[item.uid] = marker
        }
    }

}


extension MyMapView: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        if let mapItem = marker.userData as? MapItem, marker != currentMarker {
            currentMarker = marker
            lockCameraOn(marker)
            onDidTapMapItem?(mapItem)
        }

        return false
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        if gesture {
            unlockCamera()
        }
    }
    
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        lockCameraOnMe()
        return false
    }
    
}


extension MyMapView {
    
    private func moveMarker(_ marker: GMSMarker, from oldLocation: MapItemLocation?, to newLocation: MapItemLocation) {
        var duration = (oldLocation != nil) ? newLocation.ts - oldLocation!.ts + 0.1 : 0.0
        if duration > durationTreshhold {
            duration = durationTreshhold
        }
        
        let position = CLLocationCoordinate2D(latitude: newLocation.latitude, longitude: newLocation.longitude)
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(duration)
        marker.position = position
        if let data = marker.userData as? MapItem {
            if data.role == .driver {
                marker.rotation = newLocation.course
            }
            moveCameraToIfNeeded(marker)
        }
        CATransaction.commit()
    }
    
    private func moveCameraToIfNeeded(_ marker: GMSMarker) {
        if cameraLockedOnProfile && marker == currentMarker {
            let camera = GMSCameraPosition.camera(
                withLatitude: marker.position.latitude,
                longitude: marker.position.longitude,
                zoom: mapView.camera.zoom
            )
            mapView.animate(to: camera)
        }
    }
    
    private func allowLocation() {
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        mapView.settings.compassButton = true
        mapView.isHidden = false
    }
    
    private func disallowLocation() {
        mapView.isMyLocationEnabled = false
        mapView.settings.myLocationButton = false
        mapView.settings.compassButton = false
        mapView.isHidden = true
    }

}
