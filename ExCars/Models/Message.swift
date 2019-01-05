//
//  Message.swift
//  ExCars
//
//  Created by Леша on 26/11/2018.
//  Copyright © 2018 Леша. All rights reserved.
//

import CoreLocation


enum MessageType: String, Codable {
    case location = "LOCATION"
    case map = "MAP"

    case rideRequested = "RIDE_REQUESTED"
    case rideRequestAccepted = "RIDE_REQUEST_ACCEPTED"
    case rideRequestDeclined = "RIDE_REQUEST_DECLINED"
    case rideUpdated = "RIDE_UPDATED"
    case rideCancelled = "RIDE_CANCELLED"
}


struct WSMessage: Codable {
    let type: MessageType
}


struct WSLocation: Codable {
    let type = MessageType.location
    let data: WSLocationPayload
}


struct WSLocationPayload: Codable {
    let latitude: Double
    let longitude: Double
    let course: Double
    let speed : Double
}


struct WSMap: Codable {
    let type = MessageType.map
    let data: [WSMapPayload]
}


struct WSMapPayload: Codable {
    let uid: String
    let role: Role
    let hasSameRide: Bool
    let location: WSMapLocation
    
    private enum CodingKeys: String, CodingKey {
        case uid = "user_uid"
        case role
        case hasSameRide = "has_same_ride"
        case location
    }
}


struct WSMapLocation: Codable {
    let latitude: Double
    let longitude: Double
    
    var clLocation: CLLocation {
        return CLLocation(latitude: latitude, longitude: longitude)
    }
}


struct WSRide: Codable {
    let type = MessageType.rideRequested
    let data: RideRequest
}
