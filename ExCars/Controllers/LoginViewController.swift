//
//  LoginViewController.swift
//  ExCars
//
//  Created by Леша on 18/11/2018.
//  Copyright © 2018 Леша. All rights reserved.
//

import UIKit
import GoogleSignIn


class LoginViewController: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("GOOGLE SIGNIN ERROR")
            print("\(error)")
        } else {
            print("Logged In")
            APIClient.auth(idToken: user.authentication.idToken) { result in
                switch result {
                case .success(let response):
                    self.login(jwtToken: response.jwtToken)
                case .failure(let error):
                    print("AUTH ERROR")
                    print(error)
                }
            }
        }
    }
    
    private func login(jwtToken: String) {
        KeyChain.setJWTToken(token: jwtToken)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        if appDelegate.window?.rootViewController is LoginViewController {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            if let vc = sb.instantiateViewController(withIdentifier: "ViewController") as? ViewController {
                appDelegate.window!.rootViewController = vc
            }
        }
    }

}
