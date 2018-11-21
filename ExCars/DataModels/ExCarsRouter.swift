//
//  ExCarsRouter.swift
//  ExCars
//
//  Created by Леша on 19/11/2018.
//  Copyright © 2018 Леша. All rights reserved.
//


import Alamofire

public enum ExCarsRouter: URLRequestConvertible {

    enum Constants {
        static let baseURLPath = "http://localhost:8000"
    }

    case auth(String)
    case me
    
    var method: HTTPMethod {
        switch self {
        case .auth:
            return .post
        case .me:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .auth:
            return "/auth/"
        case .me:
            return "/auth/me/"
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .auth(let idToken):
            return ["id_token": idToken]
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
