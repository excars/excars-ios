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
        
        self.fullHeight = 171
        self.height = 50
        
        self.allowDismiss = true
        self.openFullView = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLoadingView()
        
        APIClient.profile(uid: uid) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let profile):
                self.profile = profile
                self.removeLoadingView()
                self.setupProfileView()
            case .failure(let error):
                print(error)
            }

        }
    }
    
    private func setupProfileView() {
        if let profile = profile {
            let frame = CGRect(x: 0.0, y: 0.0, width: view.frame.width, height: fullHeight)
            let profileView = ProfileView(profile: profile, frame: frame)
            view.addSubview(profileView)
        }
    }

    private func setupLoadingView() {
        view.addSubview(activityIndicator)
        activityIndicator.frame = view.bounds
        activityIndicator.color = UIColor.gray
        activityIndicator.startAnimating()
    }
    
    private func removeLoadingView() {
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
    }

}
