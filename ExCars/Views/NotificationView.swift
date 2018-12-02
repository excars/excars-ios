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
    var rideUid: String
    
    init(profile: Profile, rideUid: String, frame: CGRect) {
        self.rideUid = rideUid
        super.init(frame: frame)
        self.renderProfile(profile: profile)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func renderProfile(profile: Profile) {
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
    }
    
    func hide() {
        isHidden = true
    }
    
    @IBAction func accept() {
        APIClient.acceptRide(uid: rideUid) { result in
            switch result {
            case .success:
                self.isHidden = true
            case .failure(let error):
                print ("ACCEPT RIDE ERROR \(error)")
            }
        }
    }
    
    @IBAction func decline() {
        isHidden = true
    }
}
