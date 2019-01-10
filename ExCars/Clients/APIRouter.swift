//
//  ExCarsRouter.swift
//  ExCars
//
//  Created by Леша on 19/11/2018.
//  Copyright © 2018 Леша. All rights reserved.
//


import Alamofire


enum APIRouter: URLRequestConvertible {
    
    enum Constants {
        static let baseURLPath = "https://\(Configuration.API_HOST)"
    }
    
    case auth(idToken: String)
    case me
    case profile(_ uid: String)
    case join(_ role: Role, _ destination: Destination)
    case rides(_ uid: String)
    case updateRide(_ uid: String, status: PassengerStatus, passenger: Profile)
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
        case .rides:
            return .post
        case .updateRide:
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
        case .rides:
            return "/api/rides"
        case .updateRide(let uid, _, _):
            return "/api/rides/\(uid)"
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
        case .rides(let uid):
            return [
                "receiver": uid,
            ]
        case .updateRide(_, let status, let passenger):
            return [
                "status": status.rawValue,
                "passenger_uid": passenger.uid,
            ]
        default:
            return nil
        }
    }
    
    public func asURLRequest() throws -> URLRequest {
        let url = try Constants.baseURLPath.asURL()
        
        var request = URLRequest(url: url.appendingPathComponent(path))
        request.httpMethod = method.rawValue
        request.timeoutInterval = TimeInterval(1 * 1000)
        
        if let token = KeyChain.getJWTToken() {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        return try JSONEncoding.default.encode(request, with: parameters)
    }
}
