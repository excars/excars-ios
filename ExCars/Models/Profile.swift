//
//  Profile.swift
//  ExCars
//
//  Created by Леша on 26/11/2018.
//  Copyright © 2018 Леша. All rights reserved.
//

import Foundation


struct Profile: Codable {
    let id: String
    let name: String
    let avatar: URL
    let role: Role
    let destination: Destination
}


extension Profile {
    private enum CodingKeys: String, CodingKey {
        case id = "user_id"
        case name
        case avatar
        case role
        case destination
    }
}
