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
        static let baseURLPath = "http://localhost:8000"
    }
    
    case auth(String)
    case me
    case profile(String)
    case join(Role, Destination)
    case rides(String)
    case updateRide(String, String)
    
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
        case .updateRide(let uid, _):
            return "/api/rides/\(uid)"
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .auth(let idToken):
            return ["id_token": idToken]
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
                "to": uid
            ]
        case .updateRide(_, let status):
            return [
                "status": status
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
