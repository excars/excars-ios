//
//  Ride.swift
//  ExCars
//
//  Created by Леша on 16/12/2018.
//  Copyright © 2018 Леша. All rights reserved.
//

import Foundation


struct Ride: Codable {
    let uid: String
    let driver: Profile
    let passengers: [Passenger]
}


struct Passenger: Codable {
    let profile: Profile
    let status: String
}


struct RideAPIResponse: Codable {
    let uid: String
}
