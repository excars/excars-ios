//
//  AppDelegate.swift
//  ExCars
//
//  Created by Леша on 18/11/2018.
//  Copyright © 2018 Леша. All rights reserved.
//

import UIKit
import GoogleMaps
import GoogleSignIn
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        GMSServices.provideAPIKey(GMS_API_KEY)

        GIDSignIn.sharedInstance().clientID = GOOGLE_OAUTH2_CLIENT_ID
        GIDSignIn.sharedInstance().delegate = self
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = RootViewController()
        window?.makeKeyAndVisible()

        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(
            url as URL?,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )
    }

}


extension AppDelegate {

    static var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }

    var rootViewController: RootViewController {
        return window!.rootViewController as! RootViewController
    }

}


extension AppDelegate: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("GOOGLE SIGNIN ERROR: \(error)")
            return
        }
        
        APIClient.auth(idToken: user.authentication.idToken) { result in
            switch result {
            case .success(let response):
                KeyChain.setJWTToken(token: response.jwtToken)
                AppDelegate.shared.rootViewController.toMap()
            case .failure(let error):
                print("AUTH ERROR \(error)")
            }
        }
    }

}
