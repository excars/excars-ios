//
//  ProfileView.swift
//  ExCars
//
//  Created by Леша on 21/11/2018.
//  Copyright © 2018 Леша. All rights reserved.
//

import UIKit

import SDWebImage


class ProfileView: XibView {

    @IBOutlet weak var submitButton: StateButton!
    
    private var profile: Profile

    init(profile: Profile, frame: CGRect = CGRect.zero) {
        self.profile = profile
        super.init(nibName: "ProfileView", frame: frame)
        
        let profileView = BaseProfileView(profile: profile)
        profileView.frame = CGRect(x: 0, y: 0, width: frame.width, height: 142)
        addSubview(profileView)

        render()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func render() {
        switch profile.role {
        case .driver:
            submitButton.setTitle("Request a Ride", for: UIControl.State.normal)
        case .hitchhiker:
            submitButton.setTitle("Offer a Ride", for: UIControl.State.normal)
        }
    }

    @IBAction func submit() {
        submitButton.render(for: .loading)

        APIClient.ride(to: profile.uid) { result in
            switch result {
            case .success(_):
                // there is chance notification will be from another ride request/offer
                NotificationCenter.default.addObserver(
                    forName: didUpdateRide,
                    object: nil,
                    queue: nil,
                    using: self.rideUpdated
                )
            case .failure(let error):
                print("RIDE REQUEST ERROR: \(error)")
            }
        }
    }
    
    private func rideUpdated(notification: Notification) {
        guard let messageType = notification.userInfo?["messageType"] as? MessageType else { return }
        
        switch(messageType) {
        case .rideAccepted:
            submitButton.render(for: .success)
        case .rideDeclined:
            submitButton.render(for: .failure)
        default:
            break
        }

    }

}
