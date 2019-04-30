//
//  Ride.swift
//  ExCars
//
//  Created by Леша on 16/12/2018.
//  Copyright © 2018 Леша. All rights reserved.
//

import Foundation


enum PassengerStatus: String, Codable {
    case accepted = "accepted"
    case declined = "declined"
}


struct Ride: Codable {
    let id: String
    let driver: Profile
    let passengers: [Passenger]
}


extension Ride {
    private enum CodingKeys: String, CodingKey {
        case id = "ride_id"
        case driver
        case passengers
    }
}


struct Passenger: Codable {
    let profile: Profile
    let status: PassengerStatus
}
