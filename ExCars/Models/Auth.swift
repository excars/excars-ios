//
//  Auth.swift
//  ExCars
//
//  Created by Леша on 26/11/2018.
//  Copyright © 2018 Леша. All rights reserved.
//

import Foundation

typealias JWTToken = String

struct Auth: Codable {
    let jwtToken: JWTToken
}


extension Auth {
    private enum CodingKeys: String, CodingKey {
        case jwtToken = "access_token"
    }
}
