//
//  Configuration.swift
//  ExCars
//
//  Created by Леша Маслаков on 09/01/2019.
//  Copyright © 2019 Леша. All rights reserved.
//

import Foundation


struct Configuration {
    static let API_REST_URL = Bundle.main.infoDictionary!["API_REST_URL"] as! String
    static let API_WS_URL = Bundle.main.infoDictionary!["API_WS_URL"] as! String
}
