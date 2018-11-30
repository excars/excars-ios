//
//  LoginViewController.swift
//  ExCars
//
//  Created by Леша on 18/11/2018.
//  Copyright © 2018 Леша. All rights reserved.
//

import UIKit
import GoogleSignIn


class LoginViewController: UIViewController, GIDSignInUIDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        GIDSignIn.sharedInstance().uiDelegate = self

        let signInButton = GIDSignInButton()
        signInButton.frame.size = CGSize(width: 240.0, height: 44.0)
        signInButton.center = self.view.center
        
        view.backgroundColor = UIColor.white
        view.addSubview(signInButton)
    }

}
