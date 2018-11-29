//
//  ExCarsClient.swift
//  ExCars
//
//  Created by Леша on 26/11/2018.
//  Copyright © 2018 Леша. All rights reserved.
//

import Foundation

import Alamofire


class APIClient {

    @discardableResult
    private static func performRequest<T:Decodable>(route:APIRouter, decoder: JSONDecoder = JSONDecoder(), completion: @escaping (Result<T>)->Void) -> DataRequest {
        return AF.request(route)
            .responseJSONDecodable (decoder: decoder){ (response: DataResponse<T>) in
                completion(response.result)
        }
    }
    
    static func auth(idToken: String, completion: @escaping (Result<Auth>)->Void) {
        performRequest(route: APIRouter.auth(idToken), completion: completion)
    }
    
    static func profile(uid: String, completion: @escaping (Result<Profile>)->Void) {
        performRequest(route: APIRouter.profile(uid), completion: completion)
    }
    
    static func join(role: Role, destination: Destination, completion: @escaping (Result<EmptyResponse>)->Void) {
        performRequest(route: APIRouter.join(role, destination), completion: completion)
    }

    static func ride(to: String, completion: @escaping (Result<EmptyResponse>)->Void) {
        performRequest(route: APIRouter.rides(to), completion: completion)
    }
    
    static func acceptRide(uid: String, completion: @escaping (Result<EmptyResponse>)->Void) {
        performRequest(route: APIRouter.updateRide(uid, "accept"), completion: completion)
    }

}


struct EmptyResponse: Codable {
    let status: String
}
