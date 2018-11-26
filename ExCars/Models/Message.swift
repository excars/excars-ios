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
    case offerRide = "OFFER_FOR_A_RIDE"
    case offerRideAccepted = "OFFER_FOR_A_RIDE_ACCEPTED"
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


struct WSOfferRide: Codable {
    let type = MessageType.offerRide
    let data: WSOfferRidePayload
}


struct WSOfferRidePayload: Codable {
    let uid: String
}


struct WSOfferRideAccepted: Codable {
    let type = MessageType.offerRideAccepted
    let data: WSOfferRidePayload
}
