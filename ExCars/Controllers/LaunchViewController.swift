//
//  LaunchViewController.swift
//  ExCars
//
//  Created by Леша on 29/11/2018.
//  Copyright © 2018 Леша. All rights reserved.
//

import UIKit
import GoogleSignIn


class LaunchViewController: UIViewController {

    private let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        view.addSubview(activityIndicator)
        activityIndicator.frame = view.bounds
        activityIndicator.center = view.center

        activityIndicator.color = UIColor.gray
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        activityIndicator.startAnimating()
    }

}
