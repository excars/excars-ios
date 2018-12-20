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
    @IBOutlet weak var submitButton: StateButton!
    
    private var profile: Profile
    
    init(profile: Profile, frame: CGRect = CGRect.zero) {
        self.profile = profile
        super.init(nibName: "BaseProfileView", frame: frame)
        
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
        destination.text = profile.destination?.name
        avatar?.sd_setImage(with: profile.avatar, placeholderImage: UIImage(named: profile.role.rawValue))
    }
    
}
