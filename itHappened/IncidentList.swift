//
// Created by Dave Carlton on 11/30/16.
// Copyright (c) 2016 Dave Carlton. All rights reserved.
//

import Foundation

class IncidentList: NSObject, NSCoding {
    var incidents: [Incident]
    static let sharedInstance = IncidentList()
    var stagedIncident: Incident?
    let ArchiveURL = DocumentsDirectory.appendingPathComponent("incidents").standardizedFileURL.path

//    private override init() {
//    }
    
    public override init() {
        incidents = []
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(incidents, forKey: PropertyKey.incidentsKey)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        incidents = (aDecoder.decodeObject(forKey: PropertyKey.incidentsKey) as! [Incident])
    }
    
    func saveUserDefaults() {
        let result = NSKeyedArchiver.archiveRootObject(incidents, toFile: IncidentList.sharedInstance.ArchiveURL)
        if !result {
            print("Failed to save gIncidents...")
        }
    }

    func restoreUserDefaults() {
        let result =  NSKeyedUnarchiver.unarchiveObject(withFile: IncidentList.sharedInstance.ArchiveURL) as? [Incident]
        if result != nil {
            IncidentList.sharedInstance.incidents = result!
        } else {
            print("Failed to restore gIncidents...")
        }
    }

    class func allIncidents () -> [Incident] {
        return IncidentList.sharedInstance.incidents
    }

    class func incident(indexPath: IndexPath) -> Incident {
        return IncidentList.sharedInstance.incidents[indexPath.row]
    }

    class func incidents(filter: String) -> [Incident] {
        return IncidentList.sharedInstance.incidents.filter {
            $0.neighbor?.label == filter
        }
    }

    class func remove(_ incident: Incident) {
        let found = IncidentList.sharedInstance.incidents.index(of: incident)
        if found != nil {
            IncidentList.sharedInstance.incidents.remove(at: found!)
            IncidentList.sharedInstance.saveUserDefaults()
        }
    }

    class func stageIncident(_ incident: Incident) {
        IncidentList.sharedInstance.stagedIncident = incident
    }

    class func commitIncident() {
        // Save any previous stage incident
        var someIncidents = IncidentList.sharedInstance.incidents
        let aSharedIncident = IncidentList.sharedInstance.stagedIncident
        if aSharedIncident != nil {
            aSharedIncident?.stopped = Date()
            someIncidents.append(aSharedIncident!)
            IncidentList.sharedInstance.saveUserDefaults()
        }
        IncidentList.sharedInstance.incidents = someIncidents
        IncidentList.sharedInstance.stagedIncident = nil
    }

    class func setIncidents(_ incidents: [Incident]) {
        IncidentList.sharedInstance.incidents = incidents
    }

    class func staged() -> Bool {
        return IncidentList.sharedInstance.stagedIncident != nil
    }

}
