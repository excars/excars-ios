//
//  ExCarsStream.swift
//  ExCars
//
//  Created by Леша on 21/11/2018.
//  Copyright © 2018 Леша. All rights reserved.
//

import CoreLocation
import Starscream


protocol WSClientDelegate: class {
    func didReceiveDataUpdate(data: [WSMapPayload])
    func didReceiveDataUpdate(data: WSOfferRideAccepted)
    func didReceiveDataUpdate(data: WSRideOffer)
    func didSendMessage(type: MessageType)
}


protocol WSClientRideDelegate: class {
    func didReceiveDataUpdate(data: WSOfferRideAccepted)
}


class WSClient {
    
    weak var delegate: WSClientDelegate?
    weak var rideDelegate: WSClientRideDelegate?
    
    let socket: WebSocket
    let encoder = JSONEncoder()

    init() {
        var request = URLRequest(url: URL(string: "ws://localhost:8000/stream")!)
        if let token = KeyChain.getJWTToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        socket = WebSocket(request: request)
        socket.connect()
        socket.delegate = self
    }

    deinit {
        socket.disconnect(forceTimeout: 0)
        socket.delegate = nil
    }

    func sendLocation(location: CLLocation) {
        let payload = WSLocationPayload(
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude,
            course: location.course,
            speed: location.speed
        )
        
        guard let data = try? encoder.encode(WSLocation(data: payload)) else {
            print("CANT ENCODE LOCATION")
            return
        }

        socket.write(data: data)
        delegate?.didSendMessage(type: MessageType.location)
    }
    
    func requestRide(uid: String) {
        print("REQUEST RIDE \(uid)")
    }
    
}


extension WSClient: WebSocketDelegate {
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        let decoder = JSONDecoder()
        
        guard let data = text.data(using: .utf8),
            let message = try? decoder.decode(WSMessage.self, from: data) else {
                return
        }
        
        switch message.type {
        case .map:
            guard let wsMap = try? decoder.decode(WSMap.self, from: data) else {
                print("MAP FAILED TO DECODE: \(data)")
                break
            }
            delegate?.didReceiveDataUpdate(data: wsMap.data)
        case .offerRideAccepted:
            guard let wsOfferRideAccepted = try? decoder.decode(WSOfferRideAccepted.self, from: data) else {
                print("FAILED TO DECODE RIDE ACCEPTED")
                break
            }
            delegate?.didReceiveDataUpdate(data: wsOfferRideAccepted)
            rideDelegate?.didReceiveDataUpdate(data: wsOfferRideAccepted)
        case .rideOffer:
            guard let wsRideOffer = try? decoder.decode(WSRideOffer.self, from: data) else {
                print("FAILED TO RIDE OFFER")
                break
            }
            delegate?.didReceiveDataUpdate(data: wsRideOffer)
        default:
            print("NO MESSAGE TYPE \(message.type.rawValue)")
            break
        }
    }

    func websocketDidConnect(socket: WebSocketClient) {

    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        
    }

}
