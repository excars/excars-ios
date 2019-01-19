//
//  RideViewController.swift
//  ExCars
//
//  Created by Леша on 04/12/2018.
//  Copyright © 2018 Леша. All rights reserved.
//

import UIKit


class RideViewController: BottomViewController {
    private let currentUser: User
    private let wsClient: WSClient
    private let rideView: RideView
    
    init(currentUser: User, wsClient: WSClient) {
        self.currentUser = currentUser
        self.wsClient = wsClient
        self.rideView = RideView(currentUser: currentUser)

        super.init(nibName: nil, bundle: nil)

        fullHeight = 354
        height = 54

        wsClient.rideDelegate = self
        rideView.onRoleExit = showExitRoleDialog
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        rideView.frame = view.bounds
        view.addSubview(rideView)

        loadRide()
    }

    private func loadRide() {
        APIClient.currentRide() { [weak self] status, result in
            guard let self = self else { return }
            switch result {
            case .success(let ride):
                self.rideView.ride = ride
                self.currentUser.ride = ride
            case .failure(let error):
                if status != 404 {
                    print("IN ROLE RIDE FAILURE [\(status)]: \(error)")
                }
                self.rideView.ride = nil
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
        APIClient.leave() { [weak self] status, result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.currentUser.role = nil
            case .failure(let error):
                print("LEAVE ERROR \(status): \(error)")
            }
        }
    }

}


extension RideViewController: WSRideDelegate {

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
        
        currentUser.ride = nil
        rideView.ride = nil
    }

}
