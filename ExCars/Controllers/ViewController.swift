//
//  ViewController.swift
//  ExCars
//
//  Created by Леша on 18/11/2018.
//  Copyright © 2018 Леша. All rights reserved.
//

import UIKit
import GoogleMaps


class ViewController: UIViewController {

    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var profileView: ProfileView!
    @IBOutlet weak var waitingView: WaitingView!
    @IBOutlet weak var successView: SuccessView!
    @IBOutlet weak var notificationView: NotificationView!
    @IBOutlet weak var roleView: RoleView!
    
    var locationManager = CLLocationManager()
    let defaultLocation = CLLocationCoordinate2D(latitude: 34.67, longitude: 33.04)
    let zoomLevel: Float = 15.0

    let wsClient = WSClient()

    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self

        mapView.camera = GMSCameraPosition(target: defaultLocation, zoom: zoomLevel, bearing: 0, viewingAngle: 0)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.isHidden = true
        mapView.padding = UIEdgeInsets(top: self.view.safeAreaInsets.top, left: 0, bottom: 52, right: 0)
        mapView.delegate = self

        wsClient.delegate = self
        
        profileView.hide()
        profileView.wsClient = wsClient
        
        waitingView.hide()
        successView.hide()
        
        notificationView.hide()
        notificationView.wsClient = wsClient
        
        roleView.show()
        roleView.wsClient = wsClient
    }

}


extension ViewController: CLLocationManagerDelegate {
    
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


extension ViewController: GMSMapViewDelegate {

    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        if let userData = marker.userData as? WSMapPayload {
            APIClient.profile(uid: userData.uid) { result in
                switch result {
                case .success(let profile):
                    self.profileView.show(profile: profile)
                case .failure(let error):
                    print("ERROR")
                    print(error)
                }
            }
        }

        return false
    }

    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        profileView.hide()
        successView.hide()
    }

}


extension ViewController: WSClientDelegate {

    func didSendMessage(type: MessageType) {
        switch type {
        case .offerRide:
            waitingView.show()
            profileView.hide()
        case .role:
            roleView.hide()
        default:
            break
        }
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
        waitingView.hide()
        successView.show(text: "Offer for a ride accepted!")
        print("OFFER ACCEPTED")
    }
    
    func didReceiveDataUpdate(data: WSRideOffer) {
        APIClient.profile(uid: data.data.uid) { result in
            switch result {
            case .success(let profile):
                self.notificationView.show(profile: profile)
            case .failure(let error):
                print("ERROR")
                print(error)
            }
        }
    }

}
