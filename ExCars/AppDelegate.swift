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
    
    private enum RootMode {
        case launch
        case login
        case map(User)
    }

    var window: UIWindow?
    private var authObserverToken: NSObjectProtocol?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        GMSServices.provideAPIKey(GMS_API_KEY)

        GIDSignIn.sharedInstance().clientID = GOOGLE_OAUTH2_CLIENT_ID
        
        registerWSMessages()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        setupObserving()
        checkAuthenticationAndDisplayRoot()

        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(
            url as URL?,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )
    }
    
    // MARK: - private
    
    private func checkAuthenticationAndDisplayRoot() {
        if KeyChain.getJWTToken() != nil {
            updateRootController(.launch)
            AuthFacade.shared.fetchUser() { [weak self] result in
                if case .failure = result {
                    self?.updateRootController(.login)
                }
            }
        } else {
            updateRootController(.login)
        }
    }
    
    private func setupObserving() {
        authObserverToken = NotificationCenter.default
            .addObserver(forName: Notification.Name.authenticationUpdated,
                         object: nil,
                         queue: OperationQueue.main) { [weak self] _ in
                            let mode: RootMode
                            if let user = AuthFacade.shared.currentUser {
                                mode = .map(user)
                            } else {
                                mode = .login
                            }
                            self?.updateRootController(mode)
        }
    }
    
    private func updateRootController(_ mode: RootMode) {
        switch mode {
        case .launch:
            window?.rootViewController = LaunchViewController()
        case .login:
            if let current = window?.rootViewController {
                guard !(current is LoginViewController) else {
                    return
                }
                let loginController = LoginViewController()
                current.present(loginController, animated: true) {
                    self.window?.rootViewController = loginController
                }
            } else {
                window?.rootViewController = LoginViewController()
            }
        case .map(let user):
            let controller = ViewController(currentUser: user)
            let previousRootController = window?.rootViewController
            window?.rootViewController = controller
            
            if let previous = previousRootController, previous is LoginViewController {
                guard let snapshot = previous.view.snapshotView(afterScreenUpdates: false) else {
                    return
                }
                
                controller.view.addSubview(snapshot)
                controller.view.layoutIfNeeded()
                
                UIView.animate(withDuration: 0.2,
                               animations: {
                                snapshot.frame.origin.y = snapshot.frame.maxY
                },
                               completion: { _ in
                                snapshot.removeFromSuperview()
                })
            }
        }
        
    }
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        print("FETCH")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            completionHandler(.noData)
        }
    }

}


extension AppDelegate {

    func registerWSMessages() {
        Message.register(Location.self, for: .location)

        Message.register([MapItem].self, for: .map)
        Message.register(RideRequest.self, for: .rideRequested)
        Message.register(RideRequest.self, for: .rideRequestAccepted)
        Message.register(RideRequest.self, for: .rideRequestDeclined)
    }

}
