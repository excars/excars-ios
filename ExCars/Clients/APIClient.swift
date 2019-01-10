//
//  ExCarsClient.swift
//  ExCars
//
//  Created by Леша on 26/11/2018.
//  Copyright © 2018 Леша. All rights reserved.
//

import Alamofire


class APIClient {

    @discardableResult
    private static func performRequest<T:Decodable>(route:APIRouter, decoder: JSONDecoder = JSONDecoder(), completion: @escaping (Int, Result<T>)->Void) -> DataRequest {
        return AF.request(route)
            .responseJSONDecodable (decoder: decoder){ (response: DataResponse<T>) in
                completion(response.response?.statusCode ?? 500, response.result)
        }
    }

    static func auth(idToken: String, completion: @escaping (Int, Result<Auth>)->Void) {
        performRequest(route: APIRouter.auth(idToken: idToken), completion: completion)
    }
    
    static func me(completion: @escaping (Int, Result<User>)->Void) {
        performRequest(route: APIRouter.me, completion: completion)
    }
    
    static func profile(uid: String, completion: @escaping (Int, Result<Profile>)->Void) {
        performRequest(route: APIRouter.profile(uid), completion: completion)
    }
    
    static func join(role: Role, destination: Destination, completion: @escaping (Int, Result<Profile>)->Void) {
        performRequest(route: APIRouter.join(role, destination), completion: completion)
    }

    static func leave(completion: @escaping (Int, Result<Empty>)->Void) {
        performRequest(route: APIRouter.leave, completion: completion)
    }
    
    static func currentRide(completion: @escaping (Int, Result<Ride>)->Void) {
        performRequest(route: APIRouter.currentRide, completion: completion)
    }
    
    static func requestRide(to: String, completion: @escaping (Int, Result<Empty>)->Void) {
        performRequest(route: APIRouter.requestRide(to), completion: completion)
    }

    static func acceptRideRequest(uid: String, passenger: Profile, completion: @escaping (Int, Result<Empty>)->Void) {
        performRequest(route: APIRouter.updateRideRequest(uid, status: .accepted, passenger: passenger), completion: completion)
    }
    
    static func declineRideRequest(uid: String, passenger: Profile, completion: @escaping (Int, Result<Empty>)->Void) {
        performRequest(route: APIRouter.updateRideRequest(uid, status: .declined, passenger: passenger), completion: completion)
    }

}
