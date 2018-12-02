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

    override var nibName : String {
        get { return "ProfileView" }
        set { }
    }

    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var destination: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var plate: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var activityLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var profile: Profile
    let wsClient: WSClient
    
    init(profile: Profile, wsClient: WSClient, frame: CGRect) {
        self.profile = profile
        self.wsClient = wsClient
        super.init(frame: frame)
        
        self.wsClient.rideDelegate = self
        
        activityLabel.isHidden = true
        activityIndicator.isHidden = true
        render()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func render() {
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
        self.submitButton.isHidden = true
        self.activityLabel.isHidden = false
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()

        APIClient.ride(to: profile.uid) { result in
            switch result {
            case .success(_):
                break
            case .failure(let error):
                print("RIDE REQUEST ERROR: \(error)")
            }
        }
    }

}


extension ProfileView: WSClientRideDelegate {

    func didReceiveDataUpdate(data: WSOfferRideAccepted) {
        print("DID RECEIVER DATA UPDATE")
        self.activityIndicator.stopAnimating()
        self.activityIndicator.isHidden = true
        self.activityLabel.text = "Accepted"
    }

}
