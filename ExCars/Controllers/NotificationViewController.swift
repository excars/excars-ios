//
//  NotificationViewController.swift
//  ExCars
//
//  Created by Леша on 02/12/2018.
//  Copyright © 2018 Леша. All rights reserved.
//

import UIKit

class NotificationViewController: BottomViewController {

    let rideOffer: WSRideOfferPayload
    var profile: Profile?
    
    init(rideOffer: WSRideOfferPayload) {
        self.rideOffer = rideOffer

        super.init(nibName: nil, bundle: nil)

        self.fullHeight = 238
        self.height = 238
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        APIClient.profile(uid: rideOffer.from) { result in
            switch result {
            case .success(let profile):
                self.profile = profile
                self.setupNotificationView()
            case .failure(let error):
                print("NOTIFICATION PROFILE ERROR \(error)")
            }
        }
    }

    private func setupNotificationView() {
        guard let profile = profile else { return }

        let notificationView = NotificationView(profile: profile, rideUid: rideOffer.uid)
        notificationView.onDidAccept = { [weak self] in
            guard let self = self else { return }
            Presenter.dismiss(self)
        }
        notificationView.frame = view.bounds
        
        view.addSubview(notificationView)
    }

}
