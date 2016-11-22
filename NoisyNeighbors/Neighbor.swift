//
//  Neighbor.swift
//  NoisyNeighbors
//
//  Created by Dave Carlton on 10/25/16.
//  Copyright © 2016 Dave Carlton. All rights reserved.
//
import Realm
import RealmSwift

enum IncidentType {
    case dog
    case music
    case voices
    case other
}

class Incident: Object {
    dynamic var neighbor : Neighbor?
    dynamic var occured : Date = Date.init()
    dynamic var type = 0
}

class Neighbor: Object {
    dynamic var uuid : String = UUID().uuidString
    dynamic var label : String = "Label"
    dynamic var name : String = "Name"
    dynamic var address : String = "Address"
    let incidents = List<Incident>()
    
    // Specify properties to ignore (Realm won't persist these)
    
    //  override static func ignoredProperties() -> [String] {
    //    return []
    //  }
    
    override static func primaryKey() -> String? {
        return "uuid"
    }

    static func == (lhs: Neighbor, rhs: Neighbor) -> Bool {
        return lhs.uuid == rhs.uuid
    }
    
    func initWith(label: String, name: String, address: String) {
        self.label = label
        self.name = name
        self.address = address
    }
}


