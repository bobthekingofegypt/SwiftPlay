//
//  NumberedTransport.swift
//  SwiftPlay
//
//  Created by Richard Martin on 08/08/2017.
//  Copyright © 2017 Richard Martin. All rights reserved.
//

import Foundation

class NumberedTransport : Transport {
    let number: Int
    let numberOfStops: Int
    let stop: String
    let departuresEvery: Int
    
    init(type: TransportType,
         number: Int,
         location: String,
         travelTime: Int,
         time: String,
         numberOfStops: Int,
         stop: String,
         departuresEvery: Int) {
        self.number = number
        self.numberOfStops = numberOfStops
        self.stop = stop
        self.departuresEvery = departuresEvery
        super.init(location: location, travelTime: travelTime, type: type, time: time)
    }
}
