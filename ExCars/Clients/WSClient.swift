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
    func didRecieveDataUpdate(type: String, data: [String: Any])
    func didRecieveDataUpdate(type: String, data: [[String: Any]])
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
        do {
            socket.write(data: try JSONSerialization.data(withJSONObject: [
                "type": "LOCATION",
                "data": [
                    "latitude": location.coordinate.latitude,
                    "longitude": location.coordinate.longitude,
                    "course": location.course,
                    "speed": location.speed
                ]
            ]))
        } catch {
            print("[ERROR]: Can't encode JSON")
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
    
    func websocketDidConnect(socket: WebSocketClient) {
        
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        guard let data = text.data(using: .utf16),
            let jsonData = try? JSONSerialization.jsonObject(with: data),
            let jsonDict = jsonData as? [String: Any],
            let messageType = jsonDict["type"] as? String else {
                return
        }
        
        if messageType == "MAP",
            let messageData = jsonDict["data"] as? [[String: Any]] {
            delegate?.didRecieveDataUpdate(type: messageType, data: messageData)
        }
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        
    }
}
