//
//  ProfileViewController.swift
//  ExCars
//
//  Created by Леша on 02/12/2018.
//  Copyright © 2018 Леша. All rights reserved.
//

import CoreLocation
import UIKit


class ProfileViewController: BottomViewController {

    private let userId: String
    private let currentUser: User

    private var profile: Profile?
    private let profileView: ProfileView

    private let distance: Double?

    init(userId: String, currentUser: User, withDistance: Double?, wsClient: WSClient) {
        self.userId = userId
        self.currentUser = currentUser
        self.profileView = ProfileView()
        self.distance = withDistance

        super.init(nibName: nil, bundle: nil)

        fullHeight = 199.0
        height = 50.0

        allowDismiss = true
        openFullView = true

        profileView.onSubmit = requestRide
        
        wsClient.rideRequestDelegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(profileView)
        profileView.frame = view.bounds
        profileView.render(for: .loading)

        APIClient.profile(id: userId) { [weak self] status, result in
            guard let self = self else { return }

            switch result {
            case .success(let profile):
                let state = self.getState(profile: profile)
                self.profileView.render(for: state)
                self.profile = profile
            case .failure(let error):
                print("FAILED TO GET PROFILE [\(status)]: \(error)")
            }
        }
    }

    private func getState(profile: Profile) -> ProfileViewState {
        if profile.role == currentUser.role {
            return .disabled(profile, distance)
        }

        guard let ride = currentUser.ride else { return .normal(profile, distance) }

        let passengerId = (profile.role == .driver) ? currentUser.id : profile.id

        if let passenger = ride.passengers.first(where: {$0.profile.id == passengerId}) {
            switch passenger.status {
            case .accepted:
                return .accepted(profile, distance)
            case .declined:
                return .declined(profile, distance)
            }
        }

        return .normal(profile, distance)
    }

    func requestRide() {
        profileView.render(for: .requested(profile!, distance))

        APIClient.requestRide(to: userId) { status, result in
            switch result {
            case .success(_):
                return
            case .failure(let error):
                print("RIDE REQUEST ERROR: \(status): \(error)")
            }
        }
    }

}


extension ProfileViewController: WSRideRequestDelegate {

    func didAcceptRequest() {
        profileView.render(for: .accepted(profile!, distance))
    }

    func didDeclineRequest() {
        profileView.render(for: .declined(profile!, distance))
    }

}
