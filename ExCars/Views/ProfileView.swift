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

    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var destination: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var plate: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var activityLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var icon: UIImageView!
    
    private var profile: Profile
    
    init(profile: Profile, frame: CGRect = CGRect.zero) {
        self.profile = profile
        super.init(nibName: "ProfileView", frame: frame)

        activityLabel.isHidden = true
        activityIndicator.isHidden = true
        icon.isHidden = true

        render()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func render() {
        name.text = profile.name
        destination.text = profile.destination?.name.uppercased()
        if distance != nil {
            distance.text = "\(profile.distance) km away"
        }
        avatar?.sd_setImage(with: profile.avatar, placeholderImage: UIImage(named: profile.role.rawValue))
        
        switch profile.role {
        case .driver:
            plate.text = profile.plate
            submitButton.setTitle("Request a Ride", for: UIControl.State.normal)
        case .hitchhiker:
            plate.text = ""
            submitButton.setTitle("Offer a Ride", for: UIControl.State.normal)
        }
    }

    @IBAction func submit() {
        submitButton.isHidden = true
        activityLabel.isHidden = false
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()

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
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        icon.isHidden = false
        
        guard let messageType = notification.userInfo?["messageType"] as? MessageType else { return }
        
        switch(messageType) {
        case .rideAccepted:
            activityLabel.text = "Accepted"
            activityLabel.textColor = UIColor(red:0.15, green:0.68, blue:0.38, alpha:1.0)
            icon.image = UIImage(named: "check")!
        case .rideDeclined:
            activityLabel.text = "Declined"
            activityLabel.textColor = UIColor(red:0.91, green:0.30, blue:0.24, alpha:1.0)
            icon.image = UIImage(named: "close")!
        default:
            break
        }

    }

}
