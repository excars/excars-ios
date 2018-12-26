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
    private let inRoleView: InRoleView
    
    init(user: User) {
        self.user = user
        self.inRoleView = InRoleView(user: user, ride: nil)

        super.init(nibName: nil, bundle: nil)
        
        fullHeight = 354
        height = 54
        
        NotificationCenter.default.addObserver(
            forName: didUpdateRide,
            object: nil,
            queue: nil,
            using: rideUpdated
        )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        inRoleView.frame = view.bounds
        view.addSubview(inRoleView)

        loadRide()
    }
    
    private func rideUpdated(notification: Notification) {
        loadRide()
    }
    
    private func loadRide() {
        APIClient.currentRide() { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let ride):
                self.inRoleView.ride = ride
            case .failure(let error):
                print("IN ROLE RIDE FAILURE \(error)")
            }
        }
    }

}
