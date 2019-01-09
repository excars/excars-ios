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
    private let wsClient: WSClient
    private let inRoleView: InRoleView
    
    init(user: User, wsClient: WSClient) {
        self.user = user
        self.wsClient = wsClient
        self.inRoleView = InRoleView(user: user, ride: nil)

        super.init(nibName: nil, bundle: nil)

        fullHeight = 354
        height = 54

        wsClient.rideDelegate = self
        inRoleView.onRoleExit = showExitRoleDialog
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        inRoleView.frame = view.bounds
        view.addSubview(inRoleView)

        loadRide()
    }

    private func loadRide() {
        APIClient.currentRide() { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let ride):
                self.inRoleView.ride = ride
                self.user.ride = ride
            case .failure(let error):
                print("IN ROLE RIDE FAILURE \(error)")
                self.inRoleView.ride = nil
            }
        }
    }

    private func showExitRoleDialog() {
        let alertController = UIAlertController(
            title: "Role exit",
            message: "Are you sure you want to exit?",
            preferredStyle: UIAlertController.Style.alert
        )

        let exitAction = UIAlertAction(title: "Exit", style: .destructive, handler: {action -> Void in
            self.exitRole()
        })
        alertController.addAction(exitAction)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
    
    private func exitRole() {
        APIClient.leaveRide() { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.user.role = nil
            case .failure(let error):
                print("LEAVE ERROR \(error)")
            }
        }
    }

}


extension InRoleViewController: WSRideDelegate {

    func didUpdateRide() {
        self.loadRide()
    }

    func didCancelRide() {
        let alertController = UIAlertController(
            title: "Ride has been cancelled",
            message: "",
            preferredStyle: UIAlertController.Style.alert
        )
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        present(alertController, animated: true)
        
        user.ride = nil
        inRoleView.ride = nil
    }

}
