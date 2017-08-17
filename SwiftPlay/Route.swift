//
//  Route.swift
//  SwiftPlay
//
//  Created by Richard Martin on 06/08/2017.
//  Copyright © 2017 Richard Martin. All rights reserved.
//

import Foundation
import SwiftDate

struct Route {
    let id: Int
    let departureDate: DateInRegion
    let totalTime: Int
    let destination: String
    let stages: [Transport]
}
