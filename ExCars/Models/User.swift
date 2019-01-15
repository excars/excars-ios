//
//  User.swift
//  ExCars
//
//  Created by Леша on 30/11/2018.
//  Copyright © 2018 Леша. All rights reserved.
//

import CoreLocation


protocol UserDelegate: class {
    func didChangeTrip(trip: Trip?)
}


class User: Codable {
    weak var delegate: UserDelegate?

    let uid: String
    let name: String
    let avatar: URL

    var trip: Trip? {
        didSet {
            delegate?.didChangeTrip(trip: trip)
        }
    }
    var ride: Ride?
    var location: CLLocation?
}


extension User {
    private enum CodingKeys: String, CodingKey {
        case uid
        case name
        case avatar
    }
}
