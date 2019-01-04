//
//  LoginView.swift
//  ExCars
//
//  Created by Леша on 17/12/2018.
//  Copyright © 2018 Леша. All rights reserved.
//

import Foundation
import UIKit
import GoogleSignIn


class LoginView: XibView {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var signInButton: GIDSignInButton!
    
    override var nibName: String {
        get { return "LoginView"}
        set { }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        image.image = UIImage(named: "login-image")
        signInButton.colorScheme = GIDSignInButtonColorScheme.dark
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
