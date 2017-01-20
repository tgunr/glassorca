//
//  Neighbor.swift
//  NoisyNeighbors
//
//  Created by Dave Carlton on 10/25/16.
//  Copyright © 2016 Dave Carlton. All rights reserved.
//
import UIKit

struct PropertyKey {
    static let labelKey = "label"
    static let uuidKey = "uuid"
    static let nameKey = "name"
    static let addressKey = "address"
    static let neighborKey = "neighbor"
    static let occuredKey = "occured"
    static let stoppedKey = "stopped"
    static let typeKey = "type"
    static let incidentsKey = "incidents"
}

var gNeighbors: [Neighbor] = [Neighbor]()

class Neighbor: NSObject, NSCoding {

    var uuid : String = UUID().uuidString
    var label : String = "Label"
    var name : String = "Name"
    var address : String = "Address"
    
    override init() {
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(uuid, forKey: PropertyKey.uuidKey)
        aCoder.encode(label, forKey: PropertyKey.labelKey)
        aCoder.encode(name, forKey: PropertyKey.nameKey)
        aCoder.encode(address, forKey: PropertyKey.addressKey)
   }
    
    public required init?(coder aDecoder: NSCoder) {
        uuid = (aDecoder.decodeObject(forKey: PropertyKey.uuidKey) as! String)
        label = (aDecoder.decodeObject(forKey: PropertyKey.labelKey) as! String)
        name = (aDecoder.decodeObject(forKey: PropertyKey.nameKey) as! String)
        address = (aDecoder.decodeObject(forKey: PropertyKey.addressKey) as! String)
        uuid = (aDecoder.decodeObject(forKey: PropertyKey.uuidKey) as! String)
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


