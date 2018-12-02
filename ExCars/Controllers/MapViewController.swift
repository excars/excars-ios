//
//  ViewController.swift
//  ExCars
//
//  Created by Леша on 18/11/2018.
//  Copyright © 2018 Леша. All rights reserved.
//

import UIKit
import GoogleMaps


class MapViewController: UIViewController {

    var locationManager = CLLocationManager()
    let defaultLocation = CLLocationCoordinate2D(latitude: 34.67, longitude: 33.04)
    let zoomLevel: Float = 15.0

    var mapView = GMSMapView()
    
    let currentUser: User!
    
    let wsClient = WSClient()

    init(currentUser: User) {
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self

        let height = view.frame.height
        let width  = view.frame.width

        mapView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        mapView.camera = GMSCameraPosition(target: defaultLocation, zoom: zoomLevel, bearing: 0, viewingAngle: 0)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.isHidden = true
        mapView.padding = UIEdgeInsets(top: self.view.safeAreaInsets.top, left: 0, bottom: 80, right: 0)
        mapView.delegate = self
        
        view.addSubview(mapView)

        let roleVC = RoleViewController(user: currentUser)
        presentController(vc: roleVC)
        
        wsClient.delegate = self
    }
    
    private func presentController(vc: UIViewController) {
        let height = view.frame.height
        let width  = view.frame.width

        self.addChild(vc)
        self.view.addSubview(vc.view)
        vc.didMove(toParent: self)
        vc.view.frame = CGRect(x: 0, y: self.view.frame.maxY, width: width, height: height)
    }

}


extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        
        let camera = GMSCameraPosition.camera(
            withLatitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude,
            zoom: zoomLevel
        )
        
        if mapView.isHidden {
            mapView.isHidden = false
            mapView.camera = camera
        } else {
            mapView.animate(to: camera)
        }
        
        wsClient.sendLocation(location: location)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted, .denied, .notDetermined:
            mapView.isMyLocationEnabled = false
            mapView.settings.myLocationButton = false
            mapView.isHidden = true
        case .authorizedAlways, .authorizedWhenInUse:
            mapView.isMyLocationEnabled = true
            mapView.settings.myLocationButton = true
        }
    }

}


extension MapViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        guard let userData = marker.userData as? WSMapPayload else {
            return false
        }
        
        let profileVC = ProfileViewController(uid: userData.uid, wsClient: wsClient)
        presentController(vc: profileVC)

        return false
    }
    
}


extension MapViewController: WSClientDelegate {
    
    func didSendMessage(type: MessageType) {
        
    }
    
    func didReceiveDataUpdate(data: [WSMapPayload]) {
        mapView.clear()
        
        let carIcon = UIImage(named: "car")
        let hitchhikerIcon = UIImage(named: "hitchhiker")
        
        for item in data {
            let position = CLLocationCoordinate2D(latitude: item.latitude, longitude: item.longitude)
            let marker = GMSMarker(position: position)
            
            switch item.role {
            case .driver:
                marker.icon = carIcon
            case .hitchhiker:
                marker.icon = hitchhikerIcon
            }
            
            marker.userData = item
            marker.map = mapView
        }
    }
    
    func didReceiveDataUpdate(data: WSOfferRideAccepted) {
    }
    
    func didReceiveDataUpdate(data: WSRideOffer) {
        print("RIDE OFFER!")
        let notificationVC = NotificationViewController(rideOffer: data.data)
        presentController(vc: notificationVC)
    }
    
}
