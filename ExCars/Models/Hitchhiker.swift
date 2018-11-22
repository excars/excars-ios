//
//  User.swift
//  ExCars
//
//  Created by Леша on 22/11/2018.
//  Copyright © 2018 Леша. All rights reserved.
//

struct Hitchhiker {
    let uid: String
    let name: String
    let destination: String
    let distance: Double
    let avatarPath: String
    
    init(data: [String: Any]) {
        uid = data["uid"] as! String
        name = data["name"] as! String
        destination = data["destination"] as! String
        distance = data["distance"] as! Double
        avatarPath = data["avatar"] as! String
    }

}
