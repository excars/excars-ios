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
    
    private enum CodingKeys: String, CodingKey {
        case uid = "ride_uid"
        case sender
        case receiver
    }
}


struct RideAPIResponse: Codable {
    let uid: String
}
