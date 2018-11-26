//
//  WaitingView.swift
//  ExCars
//
//  Created by Леша on 26/11/2018.
//  Copyright © 2018 Леша. All rights reserved.
//

import Foundation


class WaitingView: XibView {
    override var nibName: String {
        get { return "WaitingView" }
        set { }
    }
    
    func show() {
        isHidden = false
    }
    
    func hide() {
        isHidden = true
    }
}
