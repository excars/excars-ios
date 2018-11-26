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
}


class WSClient {
    
    weak var delegate: WSClientDelegate?
    
    let socket: WebSocket
    
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

        let encoder = JSONEncoder()
        
        do {
            let data = try encoder.encode(WSLocation(data: payload))
            socket.write(data: data)
        } catch {
            print("CANT ENCODE LOCATION")
        }
    }
    
    func offerRide(uid: String) {
        print("OFFER RIDE TO \(uid)!!!")
    }
    
    func requestRide(uid: String) {
        print("REQUEST RIDE TO \(uid)!!!")
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
                fallthrough
            }
            delegate?.didReceiveDataUpdate(data: wsMap.data)
        default:
            print("NO MESSAGE TYPE")
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
