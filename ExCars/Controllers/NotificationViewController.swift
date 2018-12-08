//
//  NotificationViewController.swift
//  ExCars
//
//  Created by Леша on 02/12/2018.
//  Copyright © 2018 Леша. All rights reserved.
//

import UIKit

class NotificationViewController: BottomViewController {

    let ride: Ride

    init(ride: Ride) {
        self.ride = ride

        super.init(nibName: nil, bundle: nil)

        self.fullHeight = 238
        self.height = 238
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        setupNotificationView()
    }

    private func setupNotificationView() {
        let notificationView = NotificationView(ride: ride)

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
