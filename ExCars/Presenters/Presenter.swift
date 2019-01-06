//
//  Presenter.swift
//  ExCars
//
//  Created by Леша on 03/12/2018.
//  Copyright © 2018 Леша. All rights reserved.
//

import UIKit


class Presenter {

    static func present(_ vc: UIViewController, to: UIViewController, isBounded: Bool = false) {
        to.addChild(vc)
        to.view.addSubview(vc.view)
        vc.didMove(toParent: to)
        
        if isBounded {
            vc.view.frame = to.view.bounds
        } else {
            let height = to.view.frame.height
            let width = to.view.frame.width
            vc.view.frame = CGRect(x: 0, y: to.view.frame.maxY, width: width, height: height)
        }
    }

    static func dismiss(_ vc: UIViewController) {
        UIView.animate(withDuration: 0.3, animations: {
            let frame = vc.view.frame
            vc.view.frame = CGRect(x: 0, y: frame.height, width: frame.width, height: frame.height)
        }) {_ in
            vc.willMove(toParent: nil)
            vc.view.removeFromSuperview()
            vc.removeFromParent()
        }
    }

    static func collapse(_ vc: BottomViewController) {
        vc.toPartialView()
    }

}
