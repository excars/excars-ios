//
//  Message.swift
//  ExCars
//
//  Created by Леша on 26/11/2018.
//  Copyright © 2018 Леша. All rights reserved.
//

import Foundation


enum MessageError: Error {
    case badMessageType
}


enum MessageType: String, Codable {
    case location = "LOCATION"
    case map = "MAP"

    case rideRequested = "RIDE_REQUESTED"
    case rideRequestAccepted = "RIDE_REQUEST_ACCEPTED"
    case rideRequestDeclined = "RIDE_REQUEST_DECLINED"
    case rideUpdated = "RIDE_UPDATED"
    case rideCancelled = "RIDE_CANCELLED"
}


struct Message: Codable {
    let type: MessageType
    let payload: Any?
}


extension Message {

    private enum CodingKeys: String, CodingKey {
        case type
        case payload = "data"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decode(MessageType.self, forKey: .type)
        
        if let decode = Message.decoders[type.rawValue] {
            payload = try decode(container)
        } else {
            payload = nil
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(type, forKey: .type)
        
        if let payload = self.payload {
            guard let encode = Message.encoders[type.rawValue] else {
                let context = EncodingError.Context(codingPath: [], debugDescription: "Invalid attachment: \(type).")
                throw EncodingError.invalidValue(self, context)
            }
            
            try encode(payload, &container)
        } else {
            try container.encodeNil(forKey: .payload)
        }
    }

}


extension Message {
    private typealias MessageDecoder = (KeyedDecodingContainer<CodingKeys>) throws -> Any
    private typealias MessageEncoder = (Any, inout KeyedEncodingContainer<CodingKeys>) throws -> Void

    private static var decoders: [String: MessageDecoder] = [:]
    private static var encoders: [String: MessageEncoder] = [:]
    
    static func register<A: Codable>(_ type: A.Type, for typeName: MessageType) {
        decoders[typeName.rawValue] = { container in
            try container.decode(A.self, forKey: .payload)
        }
        
        encoders[typeName.rawValue] = { payload, container in
            try container.encode(payload as! A, forKey: .payload)
        }
    }
}
