//
//  SuccessView.swift
//  ExCars
//
//  Created by Леша on 27/11/2018.
//  Copyright © 2018 Леша. All rights reserved.
//

import Foundation

import UIKit


class SuccessView: XibView {

    override var nibName: String {
        get { return "SuccessView" }
        set { }
    }

    @IBOutlet weak var successLabel: UILabel!

    func show(text: String) {
        successLabel.text = text
        isHidden = false
    }

    func hide() {
        isHidden = true
    }
}
