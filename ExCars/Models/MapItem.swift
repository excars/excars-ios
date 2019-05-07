
//
//  MapItem.swift
//  ExCars
//
//  Created by Леша Маслаков on 13/01/2019.
//  Copyright © 2019 Леша. All rights reserved.
//

import CoreLocation
import Foundation


struct MapItem: Codable {
    let userId: String
    let role: Role
    let hasSameRide: Bool
    let location: MapItemLocation
}


extension MapItem {
    private enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case role
        case hasSameRide = "has_same_ride"
        case location
    }
}


struct MapItemLocation: Codable {
    let latitude: Double
    let longitude: Double
    let course: Double
    let ts: Double
    
    var clLocation: CLLocation {
        return CLLocation(latitude: latitude, longitude: longitude)
    }
}
