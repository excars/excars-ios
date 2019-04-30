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
    func didReceiveMapUpdate(items: [MapItem])
    func didReceiveRideRequest(rideRequest: RideRequest)
}


protocol WSRideDelegate: class {
    func didUpdateRide()
    func didCancelRide()
}


protocol WSRideRequestDelegate: class {
    func didAcceptRequest()
    func didDeclineRequest()
}


class WSClient {

    weak var delegate: WSClientDelegate?
    weak var rideDelegate: WSRideDelegate?
    weak var rideRequestDelegate: WSRideRequestDelegate?

    let socket: WebSocket
    let encoder = JSONEncoder()

    weak var timer: Timer?
    
    init() {
        let url = URL(string: "\(Configuration.API_WS_URL)/api/v1/ws")!

        var request = URLRequest(url: url)

        if let token = KeyChain.getJWTToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        socket = WebSocket(request: request)
        socket.delegate = self
    }

    deinit {
        socket.disconnect(forceTimeout: 2)
        socket.delegate = nil
    }

    func connect() {
        socket.connect()
    }
    
    func sendLocation(location: CLLocation) {
        let payload = Location(
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude,
            course: location.course,
            speed: location.speed
        )

        guard let data = try? encoder.encode(Message(type: .location, payload: payload)) else {
            print("CANT ENCODE LOCATION")
            return
        }

        socket.write(data: data)
    }

}


extension WSClient: WebSocketDelegate {
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        let decoder = JSONDecoder()
        
        guard let data = text.data(using: .utf8),
            let message = try? decoder.decode(Message.self, from: data) else {
                print("MESSAGE FAILED TO DECODE \(text)")
                return
        }

        switch message.type {
        case .map:
            delegate?.didReceiveMapUpdate(items: message.payload as! [MapItem])
        case .rideRequested:
            delegate?.didReceiveRideRequest(rideRequest: message.payload as! RideRequest)
        case .rideRequestAccepted:
            rideRequestDelegate?.didAcceptRequest()
        case .rideRequestDeclined:
            rideRequestDelegate?.didDeclineRequest()
        case .rideUpdated:
            rideDelegate?.didUpdateRide()
        case .rideCancelled:
            rideDelegate?.didCancelRide()
        default:
            print("NO MESSAGE TYPE \(data)")
            break
        }
    }

    func websocketDidConnect(socket: WebSocketClient) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 30.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.socket.write(pong: Data())
        }
    }

    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        timer?.invalidate()
        connect()
    }

    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {

    }

}
