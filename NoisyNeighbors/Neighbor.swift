//
//  Neighbor.swift
//  NoisyNeighbors
//
//  Created by Dave Carlton on 10/25/16.
//  Copyright © 2016 Dave Carlton. All rights reserved.
//

import CoreData

enum IncidentType {
    case Dog
    case Music
    case Voices
    case Other
}

class Incident {
    var neighbor : Neighbor?
    var occured : Date = Date.init()
    var type : IncidentType?
}

class Neighbor {
    var uuid : String = UUID().uuidString
    var label : String = "Label"
    var name : String = "Name"
    var address : String = "Address"
    var incidents : Array<Incident> = []
}


