//
//  RideViewCell.swift
//  ExCars
//
//  Created by Леша on 16/12/2018.
//  Copyright © 2018 Леша. All rights reserved.
//

import Foundation
import UIKit


class RideViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var statusIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func render(profile: Profile) {
        backgroundColor = UIColor(white: 1, alpha: 0)
        name.text = profile.name
        avatar?.sd_setImage(with: profile.avatar, placeholderImage: UIImage(named: profile.role.rawValue))
    }
    
    func render(profile: Profile, status: String?) {
        render(profile: profile)
        guard let status = status else { return }
        statusIcon.image = UIImage(named: status)
    }

}
