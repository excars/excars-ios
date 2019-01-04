//
//  HitchhikerInfoView.swift
//  ExCars
//
//  Created by Леша on 21/11/2018.
//  Copyright © 2018 Леша. All rights reserved.
//

import UIKit

import SDWebImage


@IBDesignable class XibView: UIView {
    
    var nibName = ""

    var view: UIView!

    init(nibName: String, frame: CGRect) {
        self.nibName = nibName
        super.init(frame: frame)
        xibSetup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    func xibSetup() {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        addSubview(view)
    }

    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView

        return view
    }

}
