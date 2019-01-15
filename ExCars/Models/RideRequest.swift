//
//  Ride.swift
//  ExCars
//
//  Created by Леша on 08/12/2018.
//  Copyright © 2018 Леша. All rights reserved.
//

import Foundation


struct RideRequest: Codable {
    let uid: String
    let sender: Profile
    let receiver: Profile
    
    var passenger: Profile {
        return (sender.role == .driver) ? receiver : sender
    }
}


extension RideRequest {
    private enum CodingKeys: String, CodingKey {
        case uid = "ride_uid"
        case sender
        case receiver
    }
}
