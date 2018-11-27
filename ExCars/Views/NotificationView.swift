//
//  NotificationView.swift
//  ExCars
//
//  Created by Леша on 27/11/2018.
//  Copyright © 2018 Леша. All rights reserved.
//

import Foundation
import UIKit

class NotificationView: XibView {

    override var nibName: String {
        get { return "NotificationView" }
        set { }
    }
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var plate: UILabel!
    @IBOutlet weak var destination: UILabel!
    
    var profile: Profile?
    var wsClient: WSClient?
    
    func show(profile: Profile) {
        self.profile = profile
        
        name.text = profile.name
        destination.text = profile.destination?.name.uppercased()
        distance.text = "\(profile.distance) km away"
        avatar?.sd_setImage(with: profile.avatar, placeholderImage: UIImage(named: profile.role.rawValue))
        
        switch profile.role {
        case .driver:
            plate.text = profile.plate
        case .hitchhiker:
            plate.text = ""
        }
        
        isHidden = false
    }
    
    func hide() {
        isHidden = true
    }
    
    @IBAction func accept() {
        if profile != nil {
            // TODO: wrong profile UID here.
            wsClient?.acceptOffer(uid: profile!.uid)
        }
        
        isHidden = true
    }
    
    @IBAction func decline() {
        isHidden = true
    }
}
