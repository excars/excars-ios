//
//  RootViewController.swift
//  ExCars
//
//  Created by Леша on 29/11/2018.
//  Copyright © 2018 Леша. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {
    
    private var currentUser: User?
    private lazy var presenter = ExclusivePresenter(to: self)
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let launchVC = LaunchViewController()
        presenter.present(launchVC, isBounded: true)
    }
    
    func toLogin() {
        presenter.present(LoginViewController(), isBounded: true)
    }

    func toMap() {
        APIClient.me() { result in
            switch result {
            case .success(let me):
                self.currentUser = me.me
                self.presenter.present(MapViewController(currentUser: me.me), isBounded: true)
            case .failure(let error):
                print("ME ERROR \(error)")
                return
            }
        }
    }

}
