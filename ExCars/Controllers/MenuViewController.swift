//
//  MenuViewController.swift
//  ExCars
//
//  Created by Леша Маслаков on 19/01/2019.
//  Copyright © 2019 Леша. All rights reserved.
//

import UIKit

import GoogleSignIn


class MenuViewController: UIViewController {
    private let currentUser: User
    
    init(currentUser: User) {
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let menuView = MenuView(currentUser: currentUser)
        menuView.onLogout = logout
        view = menuView
    }
    
    private func logout() {
        self.dismiss(animated: true, completion: nil)
        AuthFacade.shared.logout()
    }
    
}
