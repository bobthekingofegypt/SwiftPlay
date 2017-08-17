//
//  RoutesParser.swift
//  SwiftPlay
//
//  Created by Richard Martin on 06/08/2017.
//  Copyright © 2017 Richard Martin. All rights reserved.
//

import Foundation
import SwiftDate

typealias JSONDictionary = [String: Any]

class RoutesJSONParser {
    
    func parse(with data: Data?) -> [Route]? {
        let dict = jsonDictionary(with: data)
        if let dict = dict {
            return routes(with: dict)
        }
        print("broken")
        return nil
    }
    
    func jsonDictionary(with data: Data?) -> [String: Any]? {
        do {
            if let data = data,
                let json = try JSONSerialization.jsonObject(with:
                    data) as? [String: Any] {
                return json
            }
        } catch {
            print("Couldn't parse JSON. Error: \(error)")
        }
        return nil
    }
    
    func routes(with json: JSONDictionary) -> [Route]? {
        guard let items = json["items"] as? [JSONDictionary] else {
            print("Error: Couldn't find items in JSON")
            return nil
        }
        return items.flatMap { route(with: $0) }
    }
    
    func route(with dict: JSONDictionary) -> Route? {
        guard let id = dict["id"] as? Int else {
            return nil
        }
        guard let departureDateString = dict["departureDate"] as? String else {
            return nil
        }
        guard let departureDate = DateInRegion(string: departureDateString, format: .iso8601(options: .withInternetDateTimeExtended)) else {
            return nil
        }
        guard let totalTime = dict["totalTime"] as? Int else {
            return nil
        }
        guard let destination = dict["destination"] as? String else {
            return nil
        }
        guard let stagesJson = dict["stages"] as? [JSONDictionary] else {
            print("Error: Couldn't find stages in JSON")
            return nil
        }
        guard let stages = parseStages(stagesJson) else {
            return nil
        }
        
        print("returning route")
        
        return Route(id: id, departureDate: departureDate, totalTime: totalTime, destination: destination, stages: stages)
    }
    
    func parseStages(_ dict: [JSONDictionary]) -> [Transport]? {
        return dict.flatMap { stage(with: $0) }
    }

    func stage(with dict: JSONDictionary) -> Transport? {
        guard let mode = dict["mode"] as? String else {
            return nil
        }
        
        switch mode {
        case "walk":
            return parseWalkTransportStage(dict)
        default:
            return parseNumberedTransportStage(dict)
        }
    }
    
    func parseWalkTransportStage(_ dict: JSONDictionary) -> Transport? {
        guard let travelTime = dict["travelTime"] as? Int else {
            return nil
        }
        guard let time = dict["time"] as? String else {
            return nil
        }
        guard let distance = dict["distance"] as? Int else {
            return nil
        }
        guard let location = dict["location"] as? String else {
            return nil
        }
        
        return WalkTransport(location: location, travelTime: travelTime, distance: distance, time: time)
    }
    
    func parseNumberedTransportStage(_ dict: JSONDictionary) -> Transport? {
        guard let travelTime = dict["travelTime"] as? Int else {
            return nil
        }
        guard let location = dict["location"] as? String else {
            return nil
        }
        guard let number = dict["number"] as? Int else {
            return nil
        }
        guard let modeString = dict["mode"] as? String else {
            return nil
        }
        guard let time = dict["time"] as? String else {
            return nil
        }
        guard let numberOfStops = dict["numberOfStops"] as? Int else {
            return nil
        }
        guard let stop = dict["stop"] as? String else {
            return nil
        }
        guard let departuresEvery = dict["departuresEvery"] as? Int else {
            return nil
        }
        
        let mode = { () -> TransportType in
            switch modeString {
            case "bus":
                return TransportType.bus
            default:
                return TransportType.train
            }
        }()
        
        return NumberedTransport(type: mode, number: number, location: location, travelTime: travelTime, time: time, numberOfStops: numberOfStops, stop: stop, departuresEvery: departuresEvery)
    }
}
