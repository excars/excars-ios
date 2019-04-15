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
    private static func performRequest<T:Decodable>(route: APIRouter, decoder: JSONDecoder = JSONDecoder(), completion: @escaping (Int, AFResult<T>)->Void) -> DataRequest {
        return AF.request(route)
            .responseDecodable (decoder: decoder){ (response: DataResponse<T>) in
                #if DEBUG
                if let request = response.request, let httpResponse = response.response {
                    var log = "---- [ START REQUEST LOG ] ----"
                    if let url = request.url, let method = request.httpMethod {
                        log += "\nMETHOD & URL: (\(method)) \(url)"
                    }
                    log += "\nHEADERS: \(request.headers)"
                    log += "\nSTATUS: \(httpResponse.statusCode)"
                    if let data = response.data, let object = try? JSONSerialization.jsonObject(with: data, options: .allowFragments), let prettyData = try? JSONSerialization.data(withJSONObject: object, options: .prettyPrinted), let stringData = String(data: prettyData, encoding: .utf8) {
                        
                        log += "\nRESPONSE BODY: \(stringData)"
                    }
                    log += "\n---- [ END REQUEST LOG ] ----"
                    print(log)
                }
                #endif
                completion(response.response?.statusCode ?? 500, response.result)
        }
    }
    
    private func prettyString(from data: Data) -> String? {
        let object = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
        return object.flatMap(prettyString)
    }
    
    private func prettyString(from jsonObject: Any) -> String? {
        let data = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
        return data.flatMap { String(data: $0, encoding: .utf8) }
    }

    static func auth(idToken: String, completion: @escaping (Int, AFResult<Auth>)->Void) {
        performRequest(route: APIRouter.auth(idToken: idToken), completion: completion)
    }
    
    static func me(completion: @escaping (Int, AFResult<User>)->Void) {
        performRequest(route: APIRouter.me, completion: completion)
    }
    
    static func profile(uid: String, completion: @escaping (Int, AFResult<Profile>)->Void) {
        performRequest(route: APIRouter.profile(uid), completion: completion)
    }
    
    static func join(role: Role, destination: Destination, completion: @escaping (Int, AFResult<Profile>)->Void) {
        performRequest(route: APIRouter.join(role, destination), completion: completion)
    }

    static func leave(completion: @escaping (Int, AFResult<Empty>)->Void) {
        performRequest(route: APIRouter.leave, completion: completion)
    }
    
    static func currentRide(completion: @escaping (Int, AFResult<Ride>)->Void) {
        performRequest(route: APIRouter.currentRide, completion: completion)
    }
    
    static func requestRide(to: String, completion: @escaping (Int, AFResult<Empty>)->Void) {
        performRequest(route: APIRouter.requestRide(to), completion: completion)
    }

    static func accept(rideRequest: RideRequest, completion: @escaping (Int, AFResult<Empty>)->Void) {
        performRequest(route: APIRouter.updateRideRequest(rideRequest, status: .accepted), completion: completion)
    }
    
    static func decline(rideRequest: RideRequest, completion: @escaping (Int, AFResult<Empty>)->Void) {
        performRequest(route: APIRouter.updateRideRequest(rideRequest, status: .declined), completion: completion)
    }

}
