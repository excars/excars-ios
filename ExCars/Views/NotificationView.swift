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

    private let rideRequest: RideRequest

    var onDidAccept: (() -> Void)?
    var onDidDecline: (() -> Void)?

    init(rideRequest: RideRequest, frame: CGRect = CGRect.zero) {
        self.rideRequest = rideRequest
        super.init(nibName: "NotificationView", frame: frame)
        self.setupHeader(role: rideRequest.sender.role)

        let profileView = BaseProfileView(profile: rideRequest.sender)
        profileView.frame = CGRect(x: 0, y: 48, width: frame.width, height: 142)
        addSubview(profileView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupHeader(role: Role) {
        switch role {
        case .driver:
            header.text = "Someone offers to pick you"
        case .hitchhiker:
            header.text = "Someone ask you for a ride"
        }
    }

    @IBAction func accept() {
        APIClient.acceptRide(uid: rideRequest.uid, passenger: getPassenger()) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                self.onDidAccept?()
            case .failure(let error):
                print ("ACCEPT RIDE ERROR \(error)")
            }
        }
    }

    @IBAction func decline() {
        APIClient.declineRide(uid: rideRequest.uid, passenger: getPassenger()) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                self.onDidAccept?()
            case .failure(let error):
                print ("DECLINE RIDE ERROR \(error)")
            }
        }
    }
    
    private func getPassenger() -> Profile {
        if rideRequest.sender.role == Role.driver {
            return rideRequest.receiver
        }
        return rideRequest.sender
    }

}
