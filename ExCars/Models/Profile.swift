//
//  Profile.swift
//  ExCars
//
//  Created by Леша on 26/11/2018.
//  Copyright © 2018 Леша. All rights reserved.
//

import Foundation


struct Profile: Codable {
    let uid: String
    let name: String
    let avatar: URL
    let role: Role
    let destination: Destination?
    let distance: Double?
    let plate: String
}


struct Destination: Codable {
    let name: String
    let latitude: Double
    let longitude: Double
}


enum Role: String, Codable {
    case driver = "driver"
    case hitchhiker = "hitchhiker"
}
