//
//  ExclusivePresenter.swift
//  ExCars
//
//  Created by Леша on 03/12/2018.
//  Copyright © 2018 Леша. All rights reserved.
//

import Foundation
import UIKit


class ExclusivePresenter {

    private var current: UIViewController?
    private var to: UIViewController

    init(to: UIViewController) {
        self.to = to
    }
    
    func present(_ vc: UIViewController, isBounded: Bool = false) {
        Presenter.present(vc, to: to, isBounded: isBounded)
        self.dismiss()
        current = vc
    }

    func dismiss() {
        if let current = current {
            Presenter.dismiss(current)
        }
        current = nil
    }

}
