//
//  Transport.swift
//  SwiftPlay
//
//  Created by Richard Martin on 08/08/2017.
//  Copyright © 2017 Richard Martin. All rights reserved.
//

import Foundation

enum TransportType {
    case walk
    case bus
    case train
}

class Transport {
    let type: TransportType
    let location: String
    let travelTime: Int
    let time: String
    
    init(location: String, travelTime: Int, type: TransportType, time: String) {
        self.location = location
        self.travelTime = travelTime
        self.type = type
        self.time = time
    }
}
