//
//  Message.swift
//  ExCars
//
//  Created by Леша on 26/11/2018.
//  Copyright © 2018 Леша. All rights reserved.
//

import Foundation


enum MessageType: String, Codable {
    case location = "LOCATION"
    case map = "MAP"

    case rideRequested = "RIDE_REQUESTED"
    case rideAccepted = "RIDE_ACCEPTED"
    case rideDeclined = "RIDE_DECLINED"
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
    let latitude: Double
    let longitude: Double
    let role: Role
}


struct WSRide: Codable {
    let type = MessageType.rideRequested
    let data: Ride
}
