//
//  StateButton.swift
//  ExCars
//
//  Created by Леша on 18/12/2018.
//  Copyright © 2018 Леша. All rights reserved.
//

import UIKit


enum ActivityButtonState {
    case loading
    case success(String)
    case failure(String)
}


class ActivityButton: DesignableButton {
    private let activityIndicator = UIActivityIndicatorView()
    
    func render(for state: ActivityButtonState) {
        switch state {
        case .loading:
            renderLoading()
        case .success(let text):
            renderSuccess(text)
        case .failure(let text):
            renderFailure(text)
        }
    }

    private func renderLoading() {
        isEnabled = false
        setTitle("", for: .disabled)
        addActivityIndicator()
    }

    private func renderSuccess(_ text: String) {
        isEnabled = false
        removeActivityIndicator()
        
        setTitle(text, for: .disabled)
        setupImage(named: "check-white")
        backgroundColor = UIColor(named: "Green")
    }
    
    private func renderFailure(_ text: String) {
        isEnabled = false
        removeActivityIndicator()
        
        setTitle(text, for: .disabled)
        setupImage(named: "close-white")
        backgroundColor = UIColor(named: "Red")
    }
    
    private func addActivityIndicator() {
        let buttonHeight = bounds.size.height
        let buttonWidth = bounds.size.width
        activityIndicator.center = CGPoint(x: buttonWidth/2, y: buttonHeight/2)
        addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }

    private func removeActivityIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
    }
    
    private func setupImage(named: String) {
        let image = UIImage(named: named)?.withRenderingMode(.alwaysOriginal)
        setImage(image , for: .disabled)
        imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
        adjustsImageWhenDisabled = false
    }

}
