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
        mapView.delegate = self

        wsClient.delegate = self
        
        profileView.isHidden = true
        profileView.wsClient = wsClient
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
        if let userData = marker.userData as? [String:Any] {
            APIClient.profile(uid: userData["uid"] as! String) { result in
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
    }

}


extension ViewController: WSClientDelegate {

    func didRecieveDataUpdate(type: String, data: [[String : Any]]) {
        switch type {
        case "MAP":
            drawMarkers(data: data)
        default:
            print("Unknown type: \(type)")
        }
    }

    func didRecieveDataUpdate(type: String, data: [String : Any]) {

    }

    func drawMarkers(data: [[String: Any]]) {
        mapView.clear()

        let carIcon = UIImage(named: "car")
        let hitchhikerIcon = UIImage(named: "hitchhiker")
        
        for item in data {
            guard let latitude = (item["latitude"] as? NSString)?.doubleValue else {
                continue
            }
            guard let longitude = (item["longitude"] as? NSString)?.doubleValue else {
                continue
            }

            let position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let marker = GMSMarker(position: position)

            switch item["role"] as? String {
            case "driver":
                marker.icon = carIcon
            case "hitchhiker":
                marker.icon = hitchhikerIcon
            default:
                break
            }

            marker.userData = item
            marker.map = mapView
        }
    }

}
