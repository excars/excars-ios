//
//  KeyChain.swift
//  ExCars
//
//  Created by Леша on 19/11/2018.
//  Copyright © 2018 Леша. All rights reserved.
//

import KeychainAccess

class KeyChain {
    private static let keychain = Keychain(service: "com.fdooch.ExCars")
    
    static func setJWTToken(token: String) {
        keychain["jwtToken"] = token
    }
    
    static func getJWTToken() -> String! {
        return keychain["jwtToken"]
    }
}
