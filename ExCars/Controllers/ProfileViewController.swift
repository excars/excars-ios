//
//  ProfileViewController.swift
//  ExCars
//
//  Created by Леша on 02/12/2018.
//  Copyright © 2018 Леша. All rights reserved.
//

import UIKit

class ProfileViewController: BottomViewController {
    private let uid: String
    private var profile: Profile?
    private let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)

    init(uid: String) {
        self.uid = uid
        super.init(nibName: nil, bundle: nil)
        
        self.fullHeight = 217
        self.height = 0
        
        self.allowDismiss = true
        self.openFullView = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLoadingView()
        
        APIClient.profile(uid: uid) { result in
            switch result {
            case .success(let profile):
                self.profile = profile
                self.setupProfileView()
            case .failure(let error):
                print("PROFILE ERROR \(error)")
                print(error)
            }
        }
    }
    
    private func setupProfileView() {
        if let profile = profile {
            activityIndicator.removeFromSuperview()
            
            let profileView = ProfileView(profile: profile)
            view.addSubview(profileView)
            profileView.frame = view.bounds
        }
    }
    
    private func setupLoadingView() {
        view.addSubview(activityIndicator)
        activityIndicator.frame = view.bounds
        activityIndicator.color = UIColor.gray
        activityIndicator.startAnimating()
    }

}
