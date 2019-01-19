//
//  RideRequestViewController.swift
//  ExCars
//
//  Created by Леша on 02/12/2018.
//  Copyright © 2018 Леша. All rights reserved.
//

import CoreLocation
import UIKit


class RideRequestViewController: BottomViewController {

    private let rideRequest: RideRequest
    private let distance: Double?

    init(rideRequest: RideRequest, withDistance: Double?) {
        self.rideRequest = rideRequest
        self.distance = withDistance

        super.init(nibName: nil, bundle: nil)

        fullHeight = 255
        height = fullHeight
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        setupRideRequestView()
    }

    private func setupRideRequestView() {
        let rideRequestView = RideRequestView(profile: rideRequest.sender, withDistance: distance)
        view.addSubview(rideRequestView)
        rideRequestView.frame = view.bounds

        rideRequestView.onAccept = accept
        rideRequestView.onDecline = decline
    }
    
    func accept() {
        APIClient.accept(rideRequest: rideRequest) { [weak self] status, result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                Presenter.dismiss(self)
            case .failure(let error):
                print ("ACCEPT RIDE ERROR \(error)")
            }
        }
    }

    func decline() {
        APIClient.decline(rideRequest: rideRequest) { [weak self] status, result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                Presenter.dismiss(self)
            case .failure(let error):
                print ("DECLINE RIDE ERROR \(error)")
            }
        }
    }

}
