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
    private let currentUser: User

    private var profile: Profile?
    private let profileView: ProfileView

    init(uid: String, currentUser: User) {
        self.uid = uid
        self.currentUser = currentUser
        self.profileView = ProfileView()

        super.init(nibName: nil, bundle: nil)

        fullHeight = 199
        height = 50

        allowDismiss = true
        openFullView = true

        profileView.onSubmit = requestRide
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(profileView)
        profileView.frame = view.bounds
        profileView.render(for: .loading)

        APIClient.profile(uid: uid) {[weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let profile):
                let state = self.getState(profile: profile)
                self.profile = profile
                self.profileView.render(for: state)
            case .failure(let error):
                print("FAILED TO GET PROFILE \(error)")
            }

        }
    }

    private func getState(profile: Profile) -> ProfileViewState {
        if profile.role == currentUser.role {
            return .disabled(profile)
        }

        guard let ride = currentUser.ride else { return .normal(profile) }

        let passenger_uid = (profile.role == .driver) ? currentUser.uid : profile.uid

        if let passenger = ride.passengers.first(where: {$0.profile.uid == passenger_uid}) {
            switch passenger.status {
            case .accepted:
                return .accepted(profile)
            case .declined:
                return .declined(profile)
            }
        }

        return .normal(profile)
    }

    func requestRide() {
        profileView.render(for: .requested(profile!))

        APIClient.ride(to: uid) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                NotificationCenter.default.addObserver(
                    forName: didUpdateRideRequest,
                    object: nil,
                    queue: nil,
                    using: self.rideUpdated
                )
            case .failure(let error):
                print("RIDE REQUEST ERROR: \(error)")
            }
        }
    }

    private func rideUpdated(notification: Notification) {
        guard let messageType = notification.userInfo?["messageType"] as? MessageType else { return }

        switch(messageType) {
        case .rideRequestAccepted:
            profileView.render(for: .accepted(profile!))
        case .rideRequestDeclined:
            profileView.render(for: .declined(profile!))
        default:
            break
        }

    }

}
