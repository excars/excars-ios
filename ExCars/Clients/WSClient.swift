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
    func didReceiveDataUpdate(data: WSRide)
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
        var request = URLRequest(url: URL(string: "wss://\(Configuration.API_HOST)/stream")!)
        if let token = KeyChain.getJWTToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        socket = WebSocket(request: request)
        socket.delegate = self
    }

    deinit {
        socket.disconnect(forceTimeout: 0)
        socket.delegate = nil
    }

    func connect() {
        socket.connect()
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
    }

}


extension WSClient: WebSocketDelegate {
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        let decoder = JSONDecoder()
        
        guard let data = text.data(using: .utf8),
            let message = try? decoder.decode(WSMessage.self, from: data) else {
                print("MESSAGE FAILED TO DECODE \(text)")
                return
        }
        
        switch message.type {
        case .map:
            guard let wsMap = try? decoder.decode(WSMap.self, from: data) else {
                print("MAP FAILED TO DECODE: \(data)")
                break
            }
            delegate?.didReceiveDataUpdate(data: wsMap.data)
        case .rideRequested:
            guard let wsRide = try? decoder.decode(WSRide.self, from: data) else {
                print("FAILED TO RIDE OFFER")
                break
            }
            delegate?.didReceiveDataUpdate(data: wsRide)
        case .rideRequestAccepted:
            rideRequestDelegate?.didAcceptRequest()
        case .rideRequestDeclined:
            rideRequestDelegate?.didDeclineRequest()
        case .rideUpdated:
            rideDelegate?.didUpdateRide()
        case .rideCancelled:
            rideDelegate?.didCancelRide()
        default:
            print("NO MESSAGE TYPE \(message.type.rawValue)")
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
    }

    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {

    }

}
