//
//  RoleViewController.swift
//  ExCars
//
//  Created by Леша on 30/11/2018.
//  Copyright © 2018 Леша. All rights reserved.
//

import UIKit


class RoleViewController: BottomViewController {
    private let user: User

    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)

        fullHeight = 256.0
        height = 80.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupRoleView()
    }

    private func setupRoleView() {
        let roleView = RoleView(user: user)
        roleView.frame = view.bounds
        view.addSubview(roleView)
    }

}
