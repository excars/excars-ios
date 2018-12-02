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
    var profile: Profile!
    
    init(rideOffer: WSRideOfferPayload) {
        self.rideOffer = rideOffer

        super.init(nibName: nil, bundle: nil)
        
        APIClient.profile(uid: rideOffer.from) { result in
            switch result {
            case .success(let profile):
                self.profile = profile
                self.view = NotificationView(profile: profile, rideUid: rideOffer.uid, frame: CGRect(x: 0, y: 238, width: 375, height: 238))
                self.viewDidAppear(true)
            case .failure(let error):
                print("NOTIFICATION PROFILE ERROR \(error)")
            }
        }
        
        self.fullHeight = 217
        self.height = 238
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.view = UIView()
    }

}
