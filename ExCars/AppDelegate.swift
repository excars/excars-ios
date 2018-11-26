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
        
        // Initialize sign-in
        GIDSignIn.sharedInstance().clientID = GOOGLE_OAUTH2_CLIENT_ID
//        GIDSignIn.sharedInstance().delegate = self
        
        if GIDSignIn.sharedInstance().hasAuthInKeychain() {
            print("user is signed in")
            GIDSignIn.sharedInstance()?.signInSilently()
        }
//        } else {
//            print("user is NOT signed in")
//            let sb = UIStoryboard(name: "Main", bundle: nil)
//            if let vc = sb.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
//                window!.rootViewController = vc
//            }
//        }
        
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

