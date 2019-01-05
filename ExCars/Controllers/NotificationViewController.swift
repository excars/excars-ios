//
//  NotificationViewController.swift
//  ExCars
//
//  Created by Леша on 02/12/2018.
//  Copyright © 2018 Леша. All rights reserved.
//

import CoreLocation
import UIKit


class NotificationViewController: BottomViewController {

    let rideRequest: RideRequest
    let currentUser: User
    let locations: [WSMapPayload]

    init(rideRequest: RideRequest, currentUser: User, locations: [WSMapPayload]) {
        self.rideRequest = rideRequest
        self.currentUser = currentUser
        self.locations = locations

        super.init(nibName: nil, bundle: nil)

        fullHeight = 255
        height = fullHeight
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        setupNotificationView()
    }

    private func setupNotificationView() {
        var profile = rideRequest.sender
        profile.distance = getDistance()

        let notificationView = NotificationView(profile: profile)
        view.addSubview(notificationView)
        notificationView.frame = view.bounds

        notificationView.onDidAccept = accept
        notificationView.onDidDecline = decline
    }

    func accept() {
        APIClient.acceptRide(uid: rideRequest.uid, passenger: getPassenger()) { [weak self] result in
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
        APIClient.declineRide(uid: rideRequest.uid, passenger: getPassenger()) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                Presenter.dismiss(self)
            case .failure(let error):
                print ("DECLINE RIDE ERROR \(error)")
            }
        }
    }

    private func getPassenger() -> Profile {
        if rideRequest.sender.role == Role.driver {
            return rideRequest.receiver
        }
        return rideRequest.sender
    }

    private func getDistance() ->  CLLocationDistance? {
        let sender = rideRequest.sender
        let receiver = rideRequest.receiver

        let targetUid = (currentUser.uid == sender.uid) ? receiver.uid : sender.uid
        guard let targetLocation = locations.first(where: {$0.uid == targetUid})?.location else {
            return nil
        }

        return currentUser.location?.distance(from: targetLocation.clLocation)
    }

}
