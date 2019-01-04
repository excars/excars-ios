//
//  NotificationViewController.swift
//  ExCars
//
//  Created by Леша on 02/12/2018.
//  Copyright © 2018 Леша. All rights reserved.
//

import UIKit

class NotificationViewController: BottomViewController {

    let rideRequest: RideRequest

    init(rideRequest: RideRequest) {
        self.rideRequest = rideRequest

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
        let notificationView = NotificationView(rideRequest: rideRequest)
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

}
