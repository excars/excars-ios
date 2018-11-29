//
//  HitchhikerInfoView.swift
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

    var profile: Profile?
    
    func show(profile: Profile) {
        self.profile = profile

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

        self.isHidden = false
    }

    func hide() {
        self.isHidden = true
    }

    @IBAction func submit() {
        if let profile = profile {
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

}
