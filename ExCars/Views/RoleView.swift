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
    
    var wsClient: WSClient?
    
    @IBAction func selectDriver() {
        selectRole(role: Role.driver)
    }
    
    @IBAction func selectHitchhiker() {
        selectRole(role: Role.hitchhiker)
    }
    
    private func selectRole(role: Role) {
        wsClient?.selectRole(role: role)
    }
    
    func show() {
        isHidden = false
    }
    
    func hide() {
        isHidden = true
    }
}
