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
    case normal(Profile, Double?)
    case disabled(Profile, Double?)
    case requested(Profile, Double?)
    case accepted(Profile, Double?)
    case declined(Profile, Double?)
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
        case .normal(let profile, let distance):
            renderNormal(profile: profile, withDistance: distance)
        case .disabled(let profile, let distance):
            renderDisabled(profile: profile, withDistance: distance)
        case .requested(let profile, let distance):
            renderRequested(profile: profile, withDistance: distance)
        case .accepted(let profile, let distance):
            renderAccepted(profile: profile, withDistance: distance)
        case .declined(let profile, let distance):
            renderDeclined(profile: profile, withDistance: distance)
        }
    }

    private func renderLoading() {
        showSkeleton()
    }

    private func renderNormal(profile: Profile, withDistance: Double?) {
        baseProfileView.render(profile: profile, withDistance: withDistance)
        switch profile.role {
        case .driver:
            submitButton.setTitle("Request a Ride", for: .normal)
        case .hitchhiker:
            submitButton.setTitle("Offer a Ride", for: .normal)
        }
    }
    
    private func renderDisabled(profile: Profile, withDistance: Double?) {
        baseProfileView.render(profile: profile, withDistance: withDistance)
        submitButton.isHidden = true
    }

    private func renderRequested(profile: Profile, withDistance: Double?) {
        baseProfileView.render(profile: profile, withDistance: withDistance)
        submitButton.render(for: .loading)
    }
    
    private func renderAccepted(profile: Profile, withDistance: Double?) {
        baseProfileView.render(profile: profile, withDistance: withDistance)
        submitButton.render(for: .success("Accepted"))
    }
    
    private func renderDeclined(profile: Profile, withDistance: Double?) {
        baseProfileView.render(profile: profile, withDistance: withDistance)
        submitButton.render(for: .failure("Declined"))
    }

}
