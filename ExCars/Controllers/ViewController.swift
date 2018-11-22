//
//  ViewController.swift
//  ExCars
//
//  Created by Леша on 18/11/2018.
//  Copyright © 2018 Леша. All rights reserved.
//

import UIKit
import GoogleMaps
import Alamofire

class ViewController: UIViewController {

    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var hitchhikerInfoView: HitchhikerInfoView!
    
    var locationManager = CLLocationManager()
    let defaultLocation = CLLocationCoordinate2D(latitude: 34.67, longitude: 33.04)
    let zoomLevel: Float = 15.0
    
    let stream = ExCarsStream()

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

        stream.delegate = self
        
        hitchhikerInfoView.isHidden = true
        hitchhikerInfoView.stream = stream
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
        
        stream.sendLocation(location: location)

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
        Alamofire.request(ExCarsRouter.userInfo)
            .responseJSON { response in
                if let data = response.result.value as? [String: Any]{
                    let hitchhiker = Hitchhiker(data: data)
                    self.hitchhikerInfoView.setInfo(hitchhiker: hitchhiker)
                    self.hitchhikerInfoView.isHidden = false
                }
        }

        return false
    }

    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        hitchhikerInfoView.isHidden = true
    }

}


extension ViewController: ExCarsStreamDelegate {

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
