//
//  InRoleView.swift
//  ExCars
//
//  Created by Леша on 02/12/2018.
//  Copyright © 2018 Леша. All rights reserved.
//

import UIKit


class InRoleView: XibView {
    
    @IBOutlet weak var roleIcon: UIImageView!
    @IBOutlet weak var destination: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    private let user: User
    var ride: Ride? {
        didSet {
            setHeaderView()
            tableView.reloadData()
        }
    }

    init (user: User, ride: Ride?, frame: CGRect = CGRect.zero) {
        self.user = user
        self.ride = ride
        super.init(nibName: "InRoleView", frame: frame)

        setupView()
        setupTableView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        destination.text = user.destination?.name
    
        switch user.role {
        case .driver?:
            roleIcon.image = UIImage(named: "wheel")
        case .hitchhiker?:
            roleIcon.image = UIImage(named: "hitchhike-thumb-90")
        default:
            break
        }
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "HeaderViewCell", bundle: nil), forCellReuseIdentifier: "header")
        tableView.register(UINib(nibName: "RideViewCell", bundle: nil), forCellReuseIdentifier: "default")
        tableView.isScrollEnabled = true
        tableView.separatorStyle = .none
        
        setHeaderView()
    }
    
    private func setHeaderView() {
        tableView.tableHeaderView = (ride != nil) ? nil : EmptyRideView()
    }

}


extension InRoleView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let ride = ride else { return 0 }
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
        guard ride != nil else { return UIView() }
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
        guard let ride = ride else { return UITableViewCell() }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "default", for: indexPath) as! RideViewCell
        
        if indexPath.section == 0 {
            cell.render(profile: ride.driver)
        } else {
            let passenger = ride.passengers[indexPath.row]
            cell.render(profile: passenger.profile, status: passenger.status)
        }

        return cell
    }

}
