//
//  BaseProfileView.swift
//  ExCars
//
//  Created by Леша on 20/12/2018.
//  Copyright © 2018 Леша. All rights reserved.
//

import UIKit

import SDWebImage


class BaseProfileView: XibView {
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var destination: UILabel!
    @IBOutlet weak var distance: UILabel!

    override var nibName: String {
        get { return "BaseProfileView" }
        set { }
    }

    func render(profile: Profile) {
        name.text = profile.name
        destination.text = profile.destination?.name
        avatar?.sd_setImage(with: profile.avatar, placeholderImage: UIImage(named: profile.role.rawValue))
        
        if profile.distance == nil {
            distance.text = "Unknown"
        } else {
            let distanceInKm = profile.distance! / 1000.0
            distance.text = String(format: "%.1f km", distanceInKm)
        }
    }

}
