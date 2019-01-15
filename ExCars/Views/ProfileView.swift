//
//  ProfileView.swift
//  ExCars
//
//  Created by Леша on 21/11/2018.
//  Copyright © 2018 Леша. All rights reserved.
//

import UIKit

import SDWebImage
import SkeletonView


enum ProfileViewState {
    case loading
    case normal(Profile)
    case disabled(Profile)
    case requested(Profile)
    case accepted(Profile)
    case declined(Profile)
}


class ProfileView: XibView {

    @IBOutlet weak var submitButton: ActivityButton!
    @IBOutlet weak var baseProfileView: BaseProfileView!

    var onSubmit: (() -> Void)?
    
    override var nibName: String {
        get { return "ProfileView" }
        set { }
    }

    @IBAction func submit() {
        onSubmit?()
    }

    func render(for state: ProfileViewState) {
        hideSkeleton()
        submitButton.isHidden = false

        switch state {
        case .loading:
            renderLoading()
        case .normal(let profile):
            renderNormal(profile: profile)
        case .disabled(let profile):
            renderDisabled(profile: profile)
        case .requested(let profile):
            renderRequested(profile: profile)
        case .accepted(let profile):
            renderAccepted(profile: profile)
        case .declined(let profile):
            renderDeclined(profile: profile)
        }
    }

    private func renderLoading() {
        showSkeleton()
    }

    private func renderNormal(profile: Profile) {
        baseProfileView.render(profile: profile)
        switch profile.role {
        case .driver:
            submitButton.setTitle("Request a Ride", for: .normal)
        case .hitchhiker:
            submitButton.setTitle("Offer a Ride", for: .normal)
        }
    }
    
    private func renderDisabled(profile: Profile) {
        baseProfileView.render(profile: profile)
        submitButton.isHidden = true
    }

    private func renderRequested(profile: Profile) {
        baseProfileView.render(profile: profile)
        submitButton.render(for: .loading)
    }
    
    private func renderAccepted(profile: Profile) {
        baseProfileView.render(profile: profile)
        submitButton.render(for: .success("Accepted"))
    }
    
    private func renderDeclined(profile: Profile) {
        baseProfileView.render(profile: profile)
        submitButton.render(for: .failure("Declined"))
    }

}
