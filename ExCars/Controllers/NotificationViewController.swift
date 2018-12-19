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

        fullHeight = 211
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

        let dismiss = { [weak self] in
            guard let self = self else { return }
            Presenter.dismiss(self)
        }
        notificationView.onDidAccept = dismiss
        notificationView.onDidDecline = dismiss

        notificationView.frame = view.bounds
        
        view.addSubview(notificationView)
    }

}
