//
//  User.swift
//  ExCars
//
//  Created by Леша on 30/11/2018.
//  Copyright © 2018 Леша. All rights reserved.
//

import Foundation


protocol UserDelegate: class {
    func didChangeRole(role: Role?)
}


class User: Codable {
    weak var delegate: UserDelegate?

    let uid: String
    let name: String
    let avatar: URL
    
    var role: Role? {
        didSet {
            delegate?.didChangeRole(role: role)
        }
    }

    private enum CodingKeys: String, CodingKey {
        case uid
        case name
        case avatar
        case role
    }

}
