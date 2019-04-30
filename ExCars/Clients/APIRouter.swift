//
//  ExCarsRouter.swift
//  ExCars
//
//  Created by Леша on 19/11/2018.
//  Copyright © 2018 Леша. All rights reserved.
//

import Alamofire


enum APIRouter: URLRequestConvertible {

    case me
    case profile(_ id: String)
    case join(_ role: Role, _ destination: Destination)
    case leave
    case requestRide(_ id: String)
    case updateRideRequest(_ rideRequest: RideRequest, status: PassengerStatus)
    case currentRide
    case leaveRide

    var method: HTTPMethod {
        switch self {
        case .me:
            return .get
        case .profile:
            return .get
        case .join:
            return .post
        case .leave:
            return .delete
        case .requestRide:
            return .post
        case .updateRideRequest:
            return .put
        case .currentRide:
            return .get
        case .leaveRide:
            return .delete
        }
    }
    
    var path: String {
        switch self {
        case .me:
            return "/api/v1/users/me"
        case .profile(let profile_id):
            return "/api/v1/profiles/\(profile_id)"
        case .join:
            return "/api/v1/profiles"
        case .leave:
            return "/api/v1/profiles"
        case .requestRide:
            return "/api/v1/rides"
        case .updateRideRequest(let rideRequest, _):
            return "/api/v1/rides/\(rideRequest.id)"
        case .currentRide:
            return "/api/v1/rides/current"
        case .leaveRide:
            return "/api/v1/rides"
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .join(let role, let destination):
            return [
                "role": role.rawValue,
                "destination": [
                    "name": destination.name,
                    "latitude": destination.latitude,
                    "longitude": destination.longitude,
                ]
            ]
        case .requestRide(let id):
            return [
                "receiver": id,
            ]
        case .updateRideRequest(let rideRequest, let status):
            return [
                "status": status.rawValue,
                "sender": rideRequest.sender.id,
            ]
        default:
            return nil
        }
    }
    
    public func asURLRequest() throws -> URLRequest {
        let url = URL(string: "\(Configuration.API_REST_URL)")!
        
        var request = URLRequest(url: url.appendingPathComponent(path))
        request.httpMethod = method.rawValue
        request.timeoutInterval = TimeInterval(1 * 1000)
        
        if let token = KeyChain.getJWTToken() {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        return try JSONEncoding.default.encode(request, with: parameters)
    }
}
