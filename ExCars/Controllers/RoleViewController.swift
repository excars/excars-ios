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
//        self.user.delegate = self
        
        fullHeight = 256
        height = 80
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
    
//    func render(role: Role?) {
//        if role != nil {
//            self.view = InRoleView(user: user, frame: CGRect(x: 0, y: 0, width: 375, height: 52))
//            self.fullHeight = 52
//            self.height = 52
//        } else {
//            self.view = RoleView(user: user, frame: CGRect(x: 0, y: 0, width: 375, height: 256))
//        }
//
//        super.render()
//        viewDidAppear(true)
//    }

}
//
//
//extension RoleViewController: UserDelegate {
//
//    func didChangeRole(role: Role?) {
//        render(role: role)
//    }
//
//}
