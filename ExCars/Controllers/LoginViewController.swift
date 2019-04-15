//
//  LoginViewController.swift
//  ExCars
//
//  Created by Леша on 18/11/2018.
//  Copyright © 2018 Леша. All rights reserved.
//

import UIKit
import GoogleSignIn
import SkeletonView

class LoginViewController: UIViewController {
    
    private lazy var loginView: LoginView = LoginView()

    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.uiDelegate = self
        GIDSignIn.sharedInstance()?.delegate = self
    }
    
    override func loadView() {
        view = loginView
    }
    
    // MARK: - private
    
    private func showAuthError(_ error: String) {
        let alertController = UIAlertController(
            title: "Authentication error",
            message: error,
            preferredStyle: UIAlertController.Style.alert
        )
        let okAction = UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }

}

// MARK: - GIDSignInUIDelegate
extension LoginViewController: GIDSignInUIDelegate {
    
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        present(viewController, animated: true, completion: nil)
        
        loginView.setLoadingIndicatorVisible(true)
    }
    
}

// MARK: - GIDSignInDelegate
extension LoginViewController: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            showAuthError(error.localizedDescription)
            return
        }
        
        AuthFacade.shared.login(googleToken: user.authentication.idToken) { [weak self] result in
            if case .failure(let error) = result {
                self?.loginView.setLoadingIndicatorVisible(false)
                self?.showAuthError(error.localizedDescription)
            }
        }
    }
    
}
