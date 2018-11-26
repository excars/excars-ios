//
//  HitchhikerInfoView.swift
//  ExCars
//
//  Created by Леша on 21/11/2018.
//  Copyright © 2018 Леша. All rights reserved.
//

import UIKit

import SDWebImage


@IBDesignable class ProfileView: XibView {

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
    
    var wsClient: WSClient?
    var profile: Profile?
    
    func show(profile: Profile) {
        self.profile = profile

        name.text = profile.name
        destination.text = profile.destination?.name.uppercased()
        distance.text = "\(profile.distance) km away"
        avatar?.sd_setImage(with: profile.avatar, placeholderImage: UIImage(named: profile.role.rawValue))
        
        switch profile.role {
        case .driver:
            plate.text = profile.plate
            submitButton.setTitle("Request a Ride", for: UIControl.State.normal)
        case .hitchhiker:
            plate.text = ""
            submitButton.setTitle("Offer a Ride", for: UIControl.State.normal)
        }

        self.isHidden = false
    }

    func hide() {
        self.isHidden = true
    }

    @IBAction func submit() {
        if let profile = profile {
            switch profile.role {
            case .driver:
                wsClient?.requestRide(uid: profile.uid)
            case .hitchhiker:
                wsClient?.offerRide(uid: profile.uid)
            }
        }
    }

}
