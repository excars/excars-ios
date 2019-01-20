//
//  MapViewController.swift
//  ExCars
//
//  Created by Леша on 18/11/2018.
//  Copyright © 2018 Леша. All rights reserved.
//

import CoreLocation
import UIKit

import SideMenu


class MapViewController: UIViewController {

    var locationManager = CLLocationManager()
    
    var currentLocation: CLLocation?
    let currentUser: User

    lazy var exclusivePresenter = ExclusivePresenter(to: self)
    lazy var bottomPresenter = ExclusivePresenter(to: self)

    let wsClient = WSClient()

    let myView = MyMapView()

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
        myView.onDidTapMapItem = showProfile
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
    
    private func showProfile(_ mapItem: MapItem) {
        let distance = getDistance(from: mapItem)
        let profileVC = ProfileViewController(uid: mapItem.uid, currentUser: currentUser, withDistance: distance, wsClient: wsClient)

        bottomPresenter.collapse()
        exclusivePresenter.present(profileVC)
    }
    
}


extension MapViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last!
        myView.setCurrentLocation(location: location)
        wsClient.sendLocation(location: location)
        currentLocation = location
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted, .denied, .notDetermined:
            myView.isLocationAllowed = false
        case .authorizedAlways, .authorizedWhenInUse:
            myView.isLocationAllowed = true
        }
    }

}


extension MapViewController: WSClientDelegate {

    func didReceiveMapUpdate(items: [MapItem]) {
        myView.drawMapItems(items: items)
    }

    func didReceiveRideRequest(rideRequest: RideRequest) {
        let marker = myView.markers[rideRequest.sender.uid]
        let distance = getDistance(from: marker?.position)
        let rideRequestVC = RideRequestViewController(rideRequest: rideRequest, withDistance: distance)
        if let marker = marker {
            myView.lockCameraOn(marker)
        }
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

    private func getDistance(from position: CLLocationCoordinate2D?) -> CLLocationDistance? {
        if let position = position {
            let location = CLLocation(latitude: position.latitude, longitude: position.longitude)
            return currentLocation?.distance(from: location)
        }
        return nil
    }

    private func getDistance(from mapItem: MapItem) -> CLLocationDistance? {
        return currentLocation?.distance(from: mapItem.location.clLocation)
    }

}
