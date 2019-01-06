//
//  MapViewController.swift
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
    var locations: [WSMapPayload] = []
    
    var oldLocations: [String: GMSMarker] = [:]

    var mapView = GMSMapView()
    var currentMarker: GMSMarker?
    
    let currentUser: User

    lazy var exclusivePresenter = ExclusivePresenter(to: self)
    lazy var rolePresenter = ExclusivePresenter(to: self)

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

        mapView.frame = view.bounds
        mapView.camera = GMSCameraPosition(target: defaultLocation, zoom: zoomLevel, bearing: 0, viewingAngle: 0)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.isHidden = true
        mapView.padding = UIEdgeInsets(top: self.view.safeAreaInsets.top, left: 0, bottom: 80, right: 0)
        mapView.delegate = self
        view.addSubview(mapView)

        wsClient.delegate = self

        currentUser.delegate = self
        didChangeRole(role: currentUser.role)
    }

}


extension MapViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        currentUser.location = location

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

        let currentUserData = currentMarker?.userData as? WSMapPayload

        if userData.uid != currentUserData?.uid {
            let profileVC = ProfileViewController(
                uid: userData.uid, currentUser: currentUser, locations: locations, wsClient: wsClient
            )
            exclusivePresenter.present(profileVC)
            currentMarker = marker
        } else {
            exclusivePresenter.dismiss()
            currentMarker = nil
        }

        return false
    }

}


extension MapViewController: WSClientDelegate {

    func didReceiveDataUpdate(data: [WSMapPayload]) {
        locations = data
        mapView.clear()

        let carIcon = UIImage(named: "car")
        let hitchhikerIcon = UIImage(named: "hitchhiker")

        for item in data {
            let marker = oldLocations[item.uid] ?? GMSMarker()
            marker.map = mapView
            marker.groundAnchor = CGPoint(x: 0.5, y: 0.5)

            switch item.role {
            case .driver:
                marker.icon = carIcon
            case .hitchhiker:
                marker.icon = hitchhikerIcon
            }

            let userData = marker.userData as? WSMapPayload
            let duration = (userData != nil ) ? (item.location.ts - userData!.location.ts) + 0.1 : 0.0
            marker.userData = item

            let position = CLLocationCoordinate2D(latitude: item.location.latitude, longitude: item.location.longitude)

            CATransaction.begin()
            CATransaction.setAnimationDuration(duration)
            if item.role == .driver {
                marker.rotation = item.location.course
            }
            marker.position = position
            CATransaction.commit()

            oldLocations[item.uid] = marker
        }
    }

    func didReceiveDataUpdate(data: WSRide) {
        let notificationVC = NotificationViewController(
            rideRequest: data.data, currentUser: currentUser, locations: locations
        )
        exclusivePresenter.present(notificationVC)
    }

}


extension MapViewController: UserDelegate {

    func didChangeRole(role: Role?) {
        let roleVC: UIViewController

        if role == nil {
            roleVC = RoleViewController(user: currentUser)
        } else {
            roleVC = InRoleViewController(user: currentUser, wsClient: wsClient)
        }

        rolePresenter.present(roleVC)
    }

}
