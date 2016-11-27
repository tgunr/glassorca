//
//  Incident.swift
//  NoisyNeighbors
//
//  Created by Dave Carlton on 11/27/16.
//  Copyright © 2016 Dave Carlton. All rights reserved.
//

import Foundation

enum IncidentType: String {
    case Dog
    case Music
    case Voices
    case Other
    case None
}

class Incident: NSObject, NSCoding {
    var neighbor : Neighbor?
    var occured : Date = Date.init()
    var stopped : Date = Date.init()
    var type: IncidentType = .None
    
    public override init() {
        super.init()
    }
    
    func initWith(neighbor: Neighbor, type: Int) {
        self.neighbor = neighbor
        switch type {
        case 0:
            self.type = .Dog
        case 0:
            self.type = .Music
        case 0:
            self.type = .Voices
        case 0:
            self.type = .Other
        default:
            self.type = .None
        }
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(neighbor, forKey: PropertyKey.neighborKey)
        aCoder.encode(occured, forKey: PropertyKey.occuredKey)
        aCoder.encode(type, forKey: PropertyKey.typeKey)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        neighbor = (aDecoder.decodeObject(forKey: PropertyKey.neighborKey) as! Neighbor)
        occured = (aDecoder.decodeObject(forKey: PropertyKey.occuredKey) as! Date)
        type = (aDecoder.decodeObject(forKey: PropertyKey.typeKey) as! IncidentType)
    }

    func interval () -> TimeInterval {
        let then = stopped.timeIntervalSince1970
        let now = occured.timeIntervalSince1970
        return then - now
    }

    func stringFromTimeInterval(interval:TimeInterval) -> String {
        let ti = NSInteger(interval)
//        let ms = Int((interval % 1) * 1000)
        let seconds = ti % 60
        let minutes = (ti / 60) % 60
        let hours = (ti / 3600)

        return NSString(format: "%0.2d:%0.2d:%0.2d",hours,minutes,seconds) as String
    }

}


