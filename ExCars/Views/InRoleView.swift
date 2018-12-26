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
    @IBOutlet weak var tableView: UITableView!
    
    let ride: Ride
    
    init (user: User, ride: Ride, frame: CGRect = CGRect.zero) {
        self.ride = ride
        super.init(nibName: "InRoleView", frame: frame)

        switch user.role {
        case .driver?:
            self.roleLabel.text = "Porto Bello"
        case .hitchhiker?:
            self.roleLabel.text = "Hitchhiking"
        default:
            break
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "HeaderViewCell", bundle: nil), forCellReuseIdentifier: "header")
        tableView.register(UINib(nibName: "RideViewCell", bundle: nil), forCellReuseIdentifier: "default")
        tableView.isScrollEnabled = true
        tableView.separatorStyle = .none
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


extension InRoleView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return ride.passengers.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableCell(withIdentifier: "header") as! HeaderViewCell
        
        switch section {
        case 0:
            header.headerText.text = "Driver"
        case 1:
            header.headerText.text = "Passengers"
        default:
            return nil
        }
        
        return header
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 24.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "default", for: indexPath) as! RideViewCell
        let profile = (indexPath.section == 0) ? ride.driver : ride.passengers[indexPath.row].profile
        
        cell.backgroundColor = UIColor(white: 1, alpha: 0)
        cell.name.text = profile.name
        cell.avatar?.sd_setImage(with: profile.avatar, placeholderImage: UIImage(named: profile.role.rawValue))
        
        if indexPath.section > 0 {
            cell.status.image = UIImage(named: ride.passengers[indexPath.row].status)
        }
        
        return cell
    }

}
