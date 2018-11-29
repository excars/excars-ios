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

    case offerRideAccepted = "RIDE_ACCEPTED"
    case rideOffer = "RIDE_OFFER"
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


struct WSOfferRidePayload: Codable {
    let uid: String
    
    private enum CodingKeys: String, CodingKey {
        case uid = "ride_uid"
    }
}


struct WSOfferRideAccepted: Codable {
    let type = MessageType.offerRideAccepted
    let data: WSOfferRidePayload
}


struct WSRideOffer: Codable {
    let type = MessageType.rideOffer
    let data: WSRideOfferPayload
}


struct WSRideOfferPayload: Codable {
    let uid: String
    let from: String
    let to: String
    
    private enum CodingKeys: String, CodingKey {
        case uid = "ride_uid"
        case from
        case to
    }
}
