//
//  ExCarsRouter.swift
//  ExCars
//
//  Created by Леша on 19/11/2018.
//  Copyright © 2018 Леша. All rights reserved.
//

import Alamofire


enum APIRouter: URLRequestConvertible {

    case auth(idToken: String)
    case me
    case profile(_ uid: String)
    case join(_ role: Role, _ destination: Destination)
    case requestRide(_ uid: String)
    case updateRideRequest(_ rideRequest: RideRequest, status: PassengerStatus)
    case currentRide
    case leave

    var method: HTTPMethod {
        switch self {
        case .auth:
            return .post
        case .me:
            return .get
        case .profile:
            return .get
        case .join:
            return .post
        case .requestRide:
            return .post
        case .updateRideRequest:
            return .put
        case .currentRide:
            return .get
        case .leave:
            return .delete
        }
    }
    
    var path: String {
        switch self {
        case .auth:
            return "/auth/"
        case .me:
            return "/api/profiles/me/"
        case .profile(let uid):
            return "/api/profiles/\(uid)"
        case .join:
            return "/api/rides/join"
        case .requestRide:
            return "/api/rides"
        case .updateRideRequest(let rideRequest, _):
            return "/api/rides/\(rideRequest.uid)"
        case .currentRide:
            return "/api/rides/current"
        case .leave:
            return "/api/rides/leave"
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .auth(let idToken):
            return [
                "id_token": idToken,
            ]
        case .join(let role, let destination):
            return [
                "role": role.rawValue,
                "destination": [
                    "name": destination.name,
                    "latitude": destination.latitude,
                    "longitude": destination.longitude,
                ]
            ]
        case .requestRide(let uid):
            return [
                "receiver": uid,
            ]
        case .updateRideRequest(let rideRequest, let status):
            return [
                "status": status.rawValue,
                "passenger_uid": rideRequest.passenger.uid,
            ]
        default:
            return nil
        }
    }
    
    public func asURLRequest() throws -> URLRequest {
        let url = URL(string: "https://\(Configuration.API_HOST)")!
        
        var request = URLRequest(url: url.appendingPathComponent(path))
        request.httpMethod = method.rawValue
        request.timeoutInterval = TimeInterval(1 * 1000)
        
        if let token = KeyChain.getJWTToken() {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        return try JSONEncoding.default.encode(request, with: parameters)
    }
}
