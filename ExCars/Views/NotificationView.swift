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
    @IBOutlet weak var baseProfileView: BaseProfileView!

    var onDidAccept: (() -> Void)?
    var onDidDecline: (() -> Void)?

    init(profile: Profile, frame: CGRect = CGRect.zero) {
        super.init(nibName: "NotificationView", frame: frame)
        
        setupHeader(role: profile.role)
        baseProfileView.profile = profile
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
        onDidAccept?()
    }

    @IBAction func decline() {
        onDidDecline?()
    }

}
