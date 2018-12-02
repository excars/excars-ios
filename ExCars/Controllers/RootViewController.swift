//
//  RootViewController.swift
//  ExCars
//
//  Created by Леша on 29/11/2018.
//  Copyright © 2018 Леша. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {

    private var current: UIViewController
    private var currentUser: User?
    
    init() {
        current = LaunchViewController()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChild(current)
        current.view.frame = view.bounds
        view.addSubview(current.view)
        current.didMove(toParent: self)
    }
    
    func toLogin() {
        toController(controller: LoginViewController())
    }

    func toMap() {
        APIClient.me() { result in
            switch result {
            case .success(let me):
                self.currentUser = me.me
                self.toController(controller: MapViewController(currentUser: me.me))
            case .failure(let error):
                print("ME ERROR \(error)")
                return
            }
        }
    }

    private func toController(controller: UIViewController) {
        addChild(controller)
        controller.view.frame = view.bounds
        view.addSubview(controller.view)
        controller.didMove(toParent: self)

        current.willMove(toParent: nil)
        current.view.removeFromSuperview()
        current.removeFromParent()
        current = controller
    }
}
