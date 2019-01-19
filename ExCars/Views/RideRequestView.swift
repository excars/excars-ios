//
//  RideRequestView.swift
//  ExCars
//
//  Created by Леша on 27/11/2018.
//  Copyright © 2018 Леша. All rights reserved.
//

import UIKit


class RideRequestView: XibView {

    @IBOutlet weak var header: UILabel!
    @IBOutlet weak var baseProfileView: BaseProfileView!

    var onAccept: (() -> Void)?
    var onDecline: (() -> Void)?

    init(profile: Profile, withDistance: Double?, frame: CGRect = CGRect.zero) {
        super.init(nibName: "RideRequestView", frame: frame)
        
        setupHeader(role: profile.role)
        baseProfileView.render(profile: profile, withDistance: withDistance)
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
        onAccept?()
    }

    @IBAction func decline() {
        onDecline?()
    }

}
