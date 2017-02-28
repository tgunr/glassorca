//
//  IncidentsViewController.swift
//  itHappened
//
//  Created by Dave Carlton on 11/27/16.
//  Copyright © 2016 Dave Carlton. All rights reserved.
//

import UIKit

class IncidentsTableViewCell: UITableViewCell {
    @IBOutlet weak var occurredLabel: UILabel!
    @IBOutlet weak var stoppedLabel: UILabel!
    @IBOutlet weak var incidentLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
}

class IncidentsTableViewController: UITableViewController {
    private var appDelegate = UIApplication.shared.delegate as! AppDelegate
    private var localIncidents: [Incident] = IncidentList.allIncidents()
//    lazy var incidentArray: [[String: Incident]] = [[String: Incident]]()
    var selectedCells: [IndexPath]?

    @IBOutlet weak var incidentsTableView: UITableView!
    @IBOutlet weak var mergeButton: UIBarButtonItem!
    @IBOutlet weak var trashButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    @IBAction func share(_ sender: Any) {
        var body = ""
        let incidents = localIncidents.count
        let i = 0
        for i in 0..<incidents {
            let incident = localIncidents[i]
                let aDate = incident.occured
                let dateFormat = dateFormatted(aDate)
                let interval = incident.interval()
                let duration = incident.stringFromTimeInterval(interval: interval)

                body = "\(body)\(incident.type) noise occurred at: \(dateFormat)! for \(duration) minutes\n"
        }
        let neighbor = localIncidents[i].neighbor
        let name:String = neighbor!.name 
        let address:String = neighbor!.address 
        let text = "\(name)\n\(address)\n\(body)"
        let objectsToShare = [text] as [Any]
        let activityViewController = UIActivityViewController(activityItems: objectsToShare,
                                                              applicationActivities: nil)
        self.present(activityViewController, animated: true)

    }
    
    @IBAction func merge(_ sender: Any) {
        selectedCells = incidentsTableView.indexPathsForSelectedRows
        // Save any staged incident
        IncidentList.commitIncident()
        var localsToRemove = [Incident]()
        let newIncident = Incident()
        // As we iterate, the selected incident occurred date will always be earlier thab
        // the newIncident.occured on first pass.
        var earlist: Date = newIncident.occured
        // We set latest to beginning of time so first pass will cause conditional to 
        // latest to first incident encountered
        var latest: Date = Date.init(timeIntervalSince1970: 0)
        for thisIncident in selectedCells! {
            let thatIncident = localIncidents[thisIncident.row]
            if thatIncident.occured < earlist {
                earlist = thatIncident.occured
            }
            if thatIncident.stopped > latest {
                latest = thatIncident.stopped
            }
            newIncident.neighbor = thatIncident.neighbor
            newIncident.type = thatIncident.type
            localsToRemove.append(thatIncident)
        }
        newIncident.occured = earlist
        newIncident.stopped = latest
        // Remove found items from both localIncidents and global incidents
        for anIncident in localsToRemove {
            let found = localIncidents.index(of: anIncident)
            if found != nil {
                localIncidents.remove(at: found!)
            }
            IncidentList.remove(anIncident)
        }
        var someIncidents = IncidentList.sharedInstance.incidents
        someIncidents.append(newIncident)
        IncidentList.sharedInstance.incidents = someIncidents
        viewDidLoad()
        incidentsTableView.reloadData()
    }


    @IBAction func trash(_ sender: Any) {
        selectedCells = incidentsTableView.indexPathsForSelectedRows
        for theIncident in selectedCells! {
            deleteIncident(indexPath: theIncident)
        }
    }
    
    func dateFormatted(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.isLenient = true
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
//        dateFormatter.timeZone = TimeZone(abbreviation: "HST")
        let result = dateFormatter.string(from: date)
        return result
    }

    func filterIncidents() {
        let theFilter = self.title!
        localIncidents = IncidentList.incidents(filter: theFilter)
    }
    
    func deleteIncident(indexPath: IndexPath) {
        let thatIncident = IncidentList.incident(indexPath: indexPath)
        IncidentList.remove(thatIncident)
        viewDidLoad()
        incidentsTableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (localIncidents.count)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "incidentCell", for: indexPath) as! IncidentsTableViewCell
        let incident = localIncidents[indexPath.row]
        // Configure the cell...
        var aDate = incident.occured
        var dateFormat = dateFormatted(aDate)
        cell.occurredLabel.text = dateFormat
        aDate = incident.stopped
        dateFormat = dateFormatted(aDate)
        cell.stoppedLabel.text = dateFormat
        cell.incidentLabel.text = incident.type.rawValue

        let interval = incident.interval()
        cell.durationLabel.text = incident.stringFromTimeInterval(interval: interval)
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            deleteIncident(indexPath: indexPath)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)!.accessoryType = .checkmark
        selectedCells = incidentsTableView.indexPathsForSelectedRows
        setItemsEnabled()
    }

    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)!.accessoryType = .none
        selectedCells = incidentsTableView.indexPathsForSelectedRows
        setItemsEnabled()
    }

    func setItemsEnabled() {
        selectedCells = incidentsTableView.indexPathsForSelectedRows
        if selectedCells != nil {
            if (selectedCells?.count)! > 0 {
                trashButton.isEnabled = true
            } else {
                trashButton.isEnabled = false
            }
            if (selectedCells?.count)! > 1 {
                mergeButton.isEnabled = true
            } else {
                mergeButton.isEnabled = false
            }
        } else {
            trashButton.isEnabled = false
            mergeButton.isEnabled = false
        }
    }
    //    override func viewDidAppear(_ animated: Bool) {
//        viewDidLoad()
//        self.incidentsTableView.reloadData()
//    }
    
    override func viewDidLoad() {
        self.navigationItem.setRightBarButtonItems([mergeButton, trashButton, shareButton], animated: true)
        setItemsEnabled()
        filterIncidents()
    }
}
