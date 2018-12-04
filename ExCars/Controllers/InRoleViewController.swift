//
//  InRoleViewController.swift
//  ExCars
//
//  Created by Леша on 04/12/2018.
//  Copyright © 2018 Леша. All rights reserved.
//

import UIKit

class InRoleViewController: BottomViewController {
    private let user: User
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
        
        fullHeight = 52
        height = 52
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRoleView()
    }
    
    private func setupRoleView() {
        let inRoleView = InRoleView(user: user)
        inRoleView.frame = view.bounds
        view.addSubview(inRoleView)
    }

}
