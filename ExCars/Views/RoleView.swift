//
//  RoleView.swift
//  ExCars
//
//  Created by Леша on 28/11/2018.
//  Copyright © 2018 Леша. All rights reserved.
//

import Foundation


class RoleView: XibView {

    override var nibName: String {
        get { return "RoleView" }
        set { }
    }

    let destination = Destination(
        name: "Porto Bello",
        latitude: 34.6709681,
        longitude: 33.0396582
    )
    
    @IBAction func selectDriver() {
        selectRole(role: Role.driver)
    }

    @IBAction func selectHitchhiker() {
        selectRole(role: Role.hitchhiker)
    }

    private func selectRole(role: Role) {
        APIClient.join(role: role, destination: destination) { result in
            switch result {
            case .success(_):
                self.isHidden = true
            case .failure(let error):
                print("JOIN ERROR \(error)")
            }
        }
    }

    func show() {
        isHidden = false
    }

    func hide() {
        isHidden = true
    }
}
