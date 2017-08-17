//
//  Constants.swift
//  SwiftPlay
//
//  Created by Richard Martin on 08/08/2017.
//  Copyright © 2017 Richard Martin. All rights reserved.
//

import Foundation
import UIKit
import SwiftDate

struct Constants {
    
    struct Dates {
        static func currentDate() -> DateInRegion? {
            //all data is constant so lets pretend the phones date is this static
            return DateInRegion(string: "2017-08-01T17:57:00.000Z", format: .iso8601(options: .withInternetDateTimeExtended))
        }
    }
    
    struct Fonts {
        static func defaultFont(size: CGFloat) -> UIFont? {
            return UIFont(name: "Helvetica Neue", size: size)
        }
        
        static func defaultBoldFont(size: CGFloat) -> UIFont? {
            return UIFont(name: "HelveticaNeue-Bold", size: size)
        }
    }
    
    struct Colors {
        static let Blue = UIColor(red: 41/255, green: 72/255, blue: 226/255, alpha: 1.0)
        static let LightBlue = UIColor(red: 58/255, green: 157/255, blue: 254/255, alpha: 1.0)
        static let Green = UIColor(red: 87/255, green: 201/255, blue: 43/255, alpha: 1.0)
        static let Black = UIColor(red: 42/255, green: 42/255, blue: 43/255, alpha: 1.0)
        static let Red = UIColor(red: 253/255, green: 54/255, blue: 77/255, alpha: 1.0)
        static let Yellow = UIColor(red: 255/255, green: 211/255, blue: 39/255, alpha: 1.0)
        static let LightGray = UIColor(red: 236/255, green: 236/255, blue: 238/255, alpha: 1.0)
    }
}
