//
//  ProfileViewController.swift
//  ExCars
//
//  Created by Леша on 02/12/2018.
//  Copyright © 2018 Леша. All rights reserved.
//

import UIKit

class ProfileViewController: BottomViewController {
    var profile: Profile!
    let wsClient: WSClient

    init(uid: String, wsClient: WSClient) {
        self.wsClient = wsClient
        super.init(nibName: nil, bundle: nil)
        
        self.fullHeight = 217
        self.height = 0
        
        self.allowDismiss = true
        self.openFullView = true

        APIClient.profile(uid: uid) { result in
            switch result {
            case .success(let profile):
                self.profile = profile
                self.render()
            case .failure(let error):
                print("PROFILE ERROR \(error)")
                print(error)
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = UIView()
    }
    
    override func render() {
        self.view = ProfileView(profile: profile, wsClient: wsClient, frame: CGRect(x: 0, y: 217, width: 375, height: 217))
        super.render()
        viewDidAppear(true)
    }

}
