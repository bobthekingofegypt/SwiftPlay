//
//  WalkTransport.swift
//  SwiftPlay
//
//  Created by Richard Martin on 08/08/2017.
//  Copyright © 2017 Richard Martin. All rights reserved.
//

import Foundation

class WalkTransport : Transport {
    let distance: Int
    
    init(location: String, travelTime: Int, distance: Int, time: String) {
        self.distance = distance
        super.init(location: location, travelTime: travelTime, type: .walk, time: time)
    }
}
