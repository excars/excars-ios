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

    @IBOutlet weak var header: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var plate: UILabel!
    @IBOutlet weak var destination: UILabel!

    private let ride: Ride

    var onDidAccept: (() -> Void)?
    var onDidDecline: (() -> Void)?

    init(ride: Ride, frame: CGRect = CGRect.zero) {
        self.ride = ride
        super.init(nibName: "NotificationView", frame: frame)
        self.renderProfile(profile: ride.sender)
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
            header.text = "Someone offers to pick you"
            plate.text = profile.plate
        case .hitchhiker:
            header.text = "Someone ask you for a ride"
            plate.text = ""
        }
    }

    @IBAction func accept() {
        APIClient.acceptRide(uid: ride.uid, passenger: getPassenger()) { result in
            switch result {
            case .success(_):
                self.onDidAccept?()
            case .failure(let error):
                print ("ACCEPT RIDE ERROR \(error)")
            }
        }
    }

    @IBAction func decline() {
        APIClient.declineRide(uid: ride.uid, passenger: getPassenger()) { result in
            switch result {
            case .success(_):
                self.onDidAccept?()
            case .failure(let error):
                print ("DECLINE RIDE ERROR \(error)")
            }
        }
    }
    
    private func getPassenger() -> Profile {
        print("IS: \(ride.sender.role == Role.driver)")
        if ride.sender.role == Role.driver {
            return ride.receiver
        }
        return ride.sender
    }

}
