//
//  InRoleViewController.swift
//  ExCars
//
//  Created by Леша on 04/12/2018.
//  Copyright © 2018 Леша. All rights reserved.
//

import UIKit

class InRoleViewController: BottomViewController {
    private let user: User
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
        
        fullHeight = 352
        height = 52
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        APIClient.currentRide() { result in
            switch result {
            case .success(let ride):
                self.setupRoleView(ride: ride)
            case .failure(let error):
                print("IN ROLE RIDE FAILURE \(error)")
            }
        }
    }
    
    private func setupRoleView(ride: Ride) {
        let inRoleView = InRoleView(user: user, ride: ride)
        inRoleView.frame = view.bounds
        view.addSubview(inRoleView)
    }

}
