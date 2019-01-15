//
//  WelcomeViewController.swift
//  ExCars
//
//  Created by Леша on 30/11/2018.
//  Copyright © 2018 Леша. All rights reserved.
//

import UIKit


class WelcomeViewController: BottomViewController {
    private let currentUser: User

    init(user: User) {
        self.currentUser = user
        super.init(nibName: nil, bundle: nil)

        fullHeight = 256.0
        height = 80.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupWelcomeView()
    }

    private func setupWelcomeView() {
        let welcomeView = WelcomeView(currentUser: currentUser)
        welcomeView.onRoleSelect = join
        welcomeView.frame = view.bounds
        view.addSubview(welcomeView)
    }
    
    private func join(role: Role, destination: Destination) {
        APIClient.join(role: role, destination: destination) { [weak self] status, result in
            guard let self = self else { return }
            switch result {
            case .success(let profile):
                self.currentUser.trip = Trip(role: profile.role, destination: profile.destination)
            case .failure(let error):
                print("JOIN ERROR [\(status)]: \(error)")
            }
        }
    }

}
