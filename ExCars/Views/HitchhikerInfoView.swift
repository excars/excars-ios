//
//  HitchhikerInfoView.swift
//  ExCars
//
//  Created by Леша on 21/11/2018.
//  Copyright © 2018 Леша. All rights reserved.
//

import UIKit

import SDWebImage


@IBDesignable class HitchhikerInfoView: UIView {
    
    var view: UIView!
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var destination: UILabel!
    @IBOutlet weak var distance: UILabel!
    
    var stream: ExCarsStream?
    var hitchhiker: Hitchhiker?

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
        let nib = UINib(nibName: "HitchhikerInfoView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        
        return view
    }
    
    func setInfo(hitchhiker: Hitchhiker) {
        self.hitchhiker = hitchhiker

        name.text = hitchhiker.name
        destination.text = hitchhiker.destination.uppercased()
        distance.text = "\(hitchhiker.distance) km away"
        avatar?.sd_setImage(with: URL(string: hitchhiker.avatarPath), placeholderImage: UIImage(named: "hitchhiker"))
    }
    
    @IBAction func offerRide() {
        if let uid = hitchhiker?.uid {
            stream?.offerRide(uid: uid)
        }
    }
    
}
