//
//  MenuView.swift
//  ExCars
//
//  Created by Леша Маслаков on 19/01/2019.
//  Copyright © 2019 Леша. All rights reserved.
//

import UIKit


class MenuView: XibView {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var avatar: DesignableImageView!
    
    var onLogout: (() -> Void)?
    
    private let currentUser: User

    init(currentUser: User, frame: CGRect = CGRect.zero) {
        self.currentUser = currentUser
        super.init(nibName: "MenuView", frame: frame)
        
        render()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func render() {
        name.text = currentUser.name
        avatar?.sd_setImage(with: currentUser.avatar)
    }

    @IBAction func logout() {
        onLogout?()
    }
}
