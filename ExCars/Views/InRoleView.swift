//
//  InRoleView.swift
//  ExCars
//
//  Created by Леша on 02/12/2018.
//  Copyright © 2018 Леша. All rights reserved.
//

import Foundation
import UIKit


class InRoleView: XibView {
    
    @IBOutlet weak var roleLabel: UILabel!
    
    override var nibName: String {
        get { return "InRoleView" }
        set { }
    }
    
    init (user: User, frame: CGRect) {
        super.init(frame: frame)
        
        switch user.role {
        case .driver?:
            self.roleLabel.text = "Driving"
        case .hitchhiker?:
            self.roleLabel.text = "Hitchhiking"
        default:
            break
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
