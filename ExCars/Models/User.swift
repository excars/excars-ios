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
    let uid: String
    let firstName: String
    let name: String
    let avatar: URL
    
    private var _role: Role?
    var role: Role? {
        get {
            return _role
        }
        set {
            _role = newValue
            delegate?.didChangeRole(role: newValue)
        }
    }
    
    weak var delegate: UserDelegate?

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        uid = try values.decode(String.self, forKey: .uid)
        firstName = try values.decode(String.self, forKey: .firstName)
        name = try values.decode(String.self, forKey: .name)
        avatar = try values.decode(URL.self, forKey: .avatar)
        role = try? values.decode(Role.self, forKey: .role)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(uid, forKey: .uid)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(name, forKey: .name)
        try container.encode(avatar, forKey: .avatar)
        try container.encode(role, forKey: .role)
    }
    
    private enum CodingKeys: String, CodingKey {
        case uid
        case firstName = "first_name"
        case name
        case avatar
        case role
    }

}
