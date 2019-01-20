//
//  MapViewController.swift
//  ExCars
//
//  Created by Леша on 18/11/2018.
//  Copyright © 2018 Леша. All rights reserved.
//

import UIKit

import GoogleMaps
import SideMenu


class MapViewController: UIViewController {

    var locationManager = CLLocationManager()
    
    var markers: [String: GMSMarker] = [:]
    let durationTreshhold = 1.0
    
    var currentMarker: GMSMarker?
    var currentLocation: CLLocation?
    let currentUser: User

    lazy var exclusivePresenter = ExclusivePresenter(to: self)
    lazy var bottomPresenter = ExclusivePresenter(to: self)

    let wsClient = WSClient()

    private var cameraLockedOnMe: Bool = true
    private var cameraLockedOnProfile: Bool = false
    
    let myView = MyMapView()
    
    var mapView: GMSMapView {
        return myView.mapView
    }
    
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
        locationManager.distanceFilter = 10.0
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
        setupMyView()
        setupMenu()
        
        wsClient.connect()
        wsClient.delegate = self

        currentUser.delegate = self
        didChangeRole(role: currentUser.role)
    }

    private func setupMyView() {
        view.addSubview(myView)
        myView.frame = view.bounds
        myView.onDidTapSettings = showMenu
    }

    private func setupMenu() {
        let menuVC = MenuViewController(currentUser: currentUser)
        let menuNC = UISideMenuNavigationController(rootViewController: menuVC)
        menuNC.isNavigationBarHidden = true
        SideMenuManager.default.menuLeftNavigationController = menuNC
        SideMenuManager.default.menuFadeStatusBar = false
        SideMenuManager.default.menuPresentMode = .menuSlideIn
    }
    
    private func showMenu() {
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
}


extension MapViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last!

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

        wsClient.sendLocation(location: location)
        currentLocation = location
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted, .denied, .notDetermined:
            mapView.isMyLocationEnabled = false
            mapView.settings.myLocationButton = false
            mapView.settings.compassButton = false
            mapView.isHidden = true
        case .authorizedAlways, .authorizedWhenInUse:
            mapView.isMyLocationEnabled = true
            mapView.settings.myLocationButton = true
            mapView.settings.compassButton = true
        }
    }

}


extension MapViewController: GMSMapViewDelegate {

    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        guard let userData = marker.userData as? MapItem else {
            return false
        }

        let currentUserData = currentMarker?.userData as? MapItem

        if userData.uid != currentUserData?.uid {
            let distance = getDistance(from: marker.position)
            let profileVC = ProfileViewController(
                uid: userData.uid, currentUser: currentUser, withDistance: distance, wsClient: wsClient
            )
            profileVC.onDismiss = { [weak self] in
                guard let self = self else { return }
                self.currentMarker = nil
                self.unlockCamera()
            }
            bottomPresenter.collapse()
            exclusivePresenter.present(profileVC)
            currentMarker = marker
            lockCameraOnProfile()
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


extension MapViewController: WSClientDelegate {

    func didReceiveMapUpdate(items: [MapItem]) {
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

    func didReceiveRideRequest(rideRequest: RideRequest) {
        lockCameraOnProfile()
        let distance = getDistance(from: markers[rideRequest.sender.uid]?.position)
        let rideRequestVC = RideRequestViewController(rideRequest: rideRequest, withDistance: distance)
        bottomPresenter.collapse()
        exclusivePresenter.present(rideRequestVC)
    }

}


extension MapViewController: UserDelegate {

    func didChangeRole(role: Role?) {
        let bottomVC: UIViewController

        if role == nil {
            bottomVC = WelcomeViewController(currentUser: currentUser)
        } else {
            bottomVC = RideViewController(currentUser: currentUser, wsClient: wsClient)
        }

        exclusivePresenter.dismiss()
        bottomPresenter.present(bottomVC)
    }

}


extension MapViewController {

    private func lockCameraOnMe() {
        cameraLockedOnMe = true
        cameraLockedOnProfile = false
    }

    private func lockCameraOnProfile() {
        cameraLockedOnMe = false
        cameraLockedOnProfile = true
    }

    private func unlockCamera() {
        cameraLockedOnMe = false
        cameraLockedOnProfile = false
    }

    private func moveCameraToProfileIfNeeded(uid: String) {
        guard cameraLockedOnProfile == true,
            let currentUserData = currentMarker?.userData as? MapItem,
            currentUserData.uid == uid
        else {
            return
        }

        let camera = GMSCameraPosition.camera(
            withLatitude: currentUserData.location.latitude,
            longitude: currentUserData.location.longitude,
            zoom: mapView.camera.zoom
        )
        mapView.animate(to: camera)
    }

}


extension MapViewController {

    private func getDistance(from position: CLLocationCoordinate2D?) -> CLLocationDistance? {
        if let position = position {
            let location = CLLocation(latitude: position.latitude, longitude: position.longitude)
            return currentLocation?.distance(from: location)
        }
        return nil
    }

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
            moveCameraToProfileIfNeeded(uid: data.uid)
        }
        CATransaction.commit()
    }

}
