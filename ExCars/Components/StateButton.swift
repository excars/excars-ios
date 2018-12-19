//
//  StateButton.swift
//  ExCars
//
//  Created by Леша on 18/12/2018.
//  Copyright © 2018 Леша. All rights reserved.
//

import UIKit


enum ButtonState {
    case loading
    case success
    case failure
}


class StateButton: DesignableButton {
    let indicatorTag = 1040808
    
    func render(for state: ButtonState) {
        switch state {
        case .loading:
            renderLoading()
        case .success:
            renderSuccess()
        case .failure:
            renderFailure()
        }
    }
    
    private func renderLoading() {
        isEnabled = false
        setTitle("", for: .disabled)
        addActivityIndicator()
    }
    
    private func renderSuccess() {
        isEnabled = false
        removeActivityIndicator()
        
        setTitle("Accepted", for: .disabled)
        setupImage(named: "check-white")
        backgroundColor = UIColor(red: 0.18, green: 0.80, blue: 0.44, alpha: 1.0)
    }
    
    private func renderFailure() {
        isEnabled = false
        removeActivityIndicator()
        
        setTitle("Declined", for: .disabled)
        setupImage(named: "close-white")
        backgroundColor = UIColor(red: 0.91, green: 0.30, blue: 0.24, alpha: 1.0)
    }
    
    private func addActivityIndicator() {
        let indicator = UIActivityIndicatorView()
        let buttonHeight = bounds.size.height
        let buttonWidth = bounds.size.width
        indicator.center = CGPoint(x: buttonWidth/2, y: buttonHeight/2)
        indicator.tag = indicatorTag
        addSubview(indicator)
        indicator.startAnimating()
    }
    
    private func removeActivityIndicator() {
        if let indicator = viewWithTag(indicatorTag) as? UIActivityIndicatorView {
            indicator.stopAnimating()
            indicator.removeFromSuperview()
        }
    }
    
    private func setupImage(named: String) {
        let image = UIImage(named: named)?.withRenderingMode(.alwaysOriginal)
        setImage(image , for: .disabled)
        imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
        adjustsImageWhenDisabled = false
    }

}
