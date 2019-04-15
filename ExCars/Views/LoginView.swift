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
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    override var nibName: String {
        get { return "LoginView"}
        set { }
    }

    override init(frame: CGRect = CGRect.zero) {
        super.init(frame: frame)
        signInButton.colorScheme = GIDSignInButtonColorScheme.dark
        signInButton.isSkeletonable = true
        signInButton.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - actions
    
    @objc private func handleTap() {
        setLoadingIndicatorVisible(true)
    }
    
    func setLoadingIndicatorVisible(_ visible: Bool) {
        signInButton.isEnabled = !visible
        if visible {
            activityIndicatorView?.startAnimating()
        } else {
            activityIndicatorView?.stopAnimating()
        }
    }
    
}
