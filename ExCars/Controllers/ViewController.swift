//
//  ViewController.swift
//  ExCars
//
//  Created by Леша on 18/11/2018.
//  Copyright © 2018 Леша. All rights reserved.
//

import CoreLocation
import UIKit
import PushKit

import SideMenu


class ViewController: UIViewController {

    private var locationManager = CLLocationManager()
    
    private var currentLocation: CLLocation?
    private let currentUser: User

    private lazy var exclusivePresenter = ExclusivePresenter(to: self)
    private lazy var bottomPresenter = ExclusivePresenter(to: self)

    private let wsClient = WSClient()

    private let mapView = MapView()

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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        NotificationsClient.shared.requestAccess(presentController: self)
    }

    private func setupMyView() {
        view.addSubview(mapView)
        mapView.frame = view.bounds
        mapView.onDidTapSettings = showMenu
        mapView.onDidTapMapItem = showProfile
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
        let profileVC = ProfileViewController(userId: mapItem.userId, currentUser: currentUser, withDistance: distance, wsClient: wsClient)

        bottomPresenter.collapse()
        exclusivePresenter.present(profileVC)
    }
    
    private func preventIdleIfNeeded(role: Role?) {
        UIApplication.shared.isIdleTimerDisabled = false
        UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplication.backgroundFetchIntervalNever)
        if role == .driver {
            UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplication.backgroundFetchIntervalMinimum)
            UIApplication.shared.isIdleTimerDisabled = true
        }
    }

}


extension ViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last!
        mapView.setCurrentLocation(location: location)
        wsClient.sendLocation(location: location)
        currentLocation = location
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted, .denied, .notDetermined:
            mapView.isLocationAllowed = false
        case .authorizedAlways, .authorizedWhenInUse:
            mapView.isLocationAllowed = true
        @unknown default:
            break
        }
    }

}


extension ViewController: WSClientDelegate {

    func didReceiveMapUpdate(items: [MapItem]) {
        mapView.drawMapItems(items: items)
    }

    func didReceiveRideRequest(rideRequest: RideRequest) {
        let marker = mapView.markers[rideRequest.sender.id]
        let distance = getDistance(from: marker?.position)
        let rideRequestVC = RideRequestViewController(rideRequest: rideRequest, withDistance: distance)
        if let marker = marker {
            mapView.lockCameraOn(marker)
        }
        bottomPresenter.collapse()
        exclusivePresenter.present(rideRequestVC)
    }

}


extension ViewController: UserDelegate {

    func didChangeRole(role: Role?) {
        let bottomVC: UIViewController
        
        if role == nil {
            bottomVC = WelcomeViewController(currentUser: currentUser)
        } else {
            bottomVC = RideViewController(currentUser: currentUser, wsClient: wsClient)
        }
        preventIdleIfNeeded(role: role)
        exclusivePresenter.dismiss()
        bottomPresenter.present(bottomVC)
    }

}


extension ViewController {

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
