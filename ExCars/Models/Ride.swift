//
//  Ride.swift
//  ExCars
//
//  Created by Леша on 08/12/2018.
//  Copyright © 2018 Леша. All rights reserved.
//

import Foundation


struct Ride: Codable {
    let uid: String
    let sender: Profile
    let receiver: Profile
}


struct RideAPIResponse: Codable {
    let uid: String
    let sender: String
    let receiver: String
}
