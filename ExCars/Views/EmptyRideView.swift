//
//  EmptyRideView.swift
//  ExCars
//
//  Created by Леша Маслаков on 26/12/2018.
//  Copyright © 2018 Леша. All rights reserved.
//

import UIKit


class EmptyRideView: XibView {

    init (frame: CGRect = CGRect.zero) {
        super.init(nibName: "EmptyRideView", frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
